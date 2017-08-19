// Copyright 2017 Google Inc. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

provider "google" {
  credentials = "${file("konterraform-f36234d1ed7d.json")}"
  project     = "konterraform"
  region      = "europe-west1"
}

//
// Gitlab Instance
//

resource "google_compute_address" "gitlab-ip" {
  name = "gitlab-address"
}

resource "google_compute_instance" "gitlab" {
  name         = "${format("gitlab-%d", count.index)}"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  tags         = ["gitlab"]

  disk {
    image = "coreos-stable-1409-5-0-v20170623"
    auto_delete  = true
    type         = "pd-ssd"
  }

  network_interface {
      network = "default"
      access_config {
        nat_ip="${google_compute_address.gitlab-ip.address}"
      }
  }
  depends_on = ["google_compute_instance.kontena-master","google_compute_instance_group_manager.workers","google_compute_address.gitlab-ip"]
  count = 1
  lifecycle = {
    create_before_destroy = true
  }
  metadata  {
    user-data="${data.template_file.gitlab_cloud_config.rendered}"
  }
}


//
// MASTER INSTANCES
//

resource "google_compute_address" "master-ip" {
  name = "master-address"
}

resource "google_compute_instance" "kontena-master" {
  name         = "${format("kontena-master-%d", count.index)}"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  tags         = ["kontena-master"]

  disk {
    image = "coreos-stable-1409-5-0-v20170623"
    auto_delete  = true
    type         = "pd-ssd"
  }

  network_interface {
      network = "default"
      access_config {
        nat_ip="${google_compute_address.master-ip.address}"
      }
  }
  depends_on = ["google_compute_address.master-ip"]
  count = 1
  lifecycle = {
    create_before_destroy = true
  }
  metadata  {
    user-data="${data.template_file.cloud_config.rendered}"
  }
}

//
// NETWORKING
//

resource "google_compute_firewall" "fwrule" {
    name = "kontena-fwr"
    network = "default"
    allow {
        protocol = "tcp"
        ports = ["80","443","22"]
    }

}


// PHERIPERALS

data "template_file" "cloud_config" {

    template = "${file("cloud-config.yaml.tpl")}"

  vars {
    KONTENA_VERSION = "1.3"
    KONTENA_VAULT_KEY = "31m2lqP54cbS6HsI2OV0bF2ZEgbPxNrkpq7laDqmApUzJd2mC0MZcSozKYoH51PY"
    KONTENA_VAULT_IV = "KGzwfRB908S8DhFhozln0pYTFQfg47GCSpUDRl9UQxy8l9Pd2jgdvmZQYSb5eyuw"
    KONTENA_INITIAL_ADMIN_CODE = "Demo600"
  }
    
}

data "template_file" "gitlab_cloud_config" {

    template = "${file("gitlab-cloud-config.yaml.tpl")}" 
}


// WORKER NODES

resource "google_compute_backend_service" "worker-node" {
  name        = "worker-node"
  description = "Worker nodes backend service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group_manager.workers.instance_group}"
  }

  health_checks = ["${google_compute_http_health_check.default.self_link}"]
}

resource "google_compute_instance_group_manager" "workers" {
  name               = "kontena-test"
  instance_template  = "${google_compute_instance_template.worker-node.self_link}"
  base_instance_name = "worker-node"
  zone               = "europe-west1-b"
  target_size        = 3
  
  named_port {
    name = "http"
    port = 80
  }
  depends_on = ["google_compute_instance.kontena-master"]
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "scaler"
  zone   = "europe-west1-b"
  target = "${google_compute_instance_group_manager.workers.self_link}"

  autoscaling_policy = {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_instance_template" "worker-node" {
  name         = "kontena-test"
  machine_type = "g1-small"

  network_interface {
    network = "default"
    access_config {
      //Ephemeral IP address
    }
  }

  disk {
    source_image = "coreos-stable-1409-7-0-v20170719"
    auto_delete  = true
    type         = "pd-ssd"
  }
  metadata  {
    user-data="${data.template_file.cloud_config_nodes.rendered}"
  }

}

resource "google_compute_http_health_check" "default" {
  name               = "test"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

data "template_file" "cloud_config_nodes" {

    template = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/cloud-config-node.yaml.tpl")}"

  vars {
    KONTENA_VERSION="1.3"
    KONTENA_URI="https://10.132.0.2"
    KONTENA_TOKEN="asd123asd"
    KONTENA_PEER_INTERFACE="ens4v1"
   
   }
    
}

// HTTPS PROXY FOR WORKER NODES

resource "google_compute_target_https_proxy" "default" {
  name             = "worker-proxy"
  description      = "HTTPS proxy for worker nodes"
  url_map          = "${google_compute_url_map.default.self_link}"
  ssl_certificates = ["${google_compute_ssl_certificate.default.self_link}"]
}

resource "google_compute_ssl_certificate" "default" {
  name        = "my-certificate"
  description = "a description"
  private_key = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/private.key")}"
  certificate = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/public.crt")}"
}

resource "google_compute_url_map" "default" {
  name        = "url-map"
  description = "a description"

  default_service = "${google_compute_backend_service.worker-node.self_link}"

  host_rule {
    hosts        = ["www.demo.io"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.worker-node.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.worker-node.self_link}"
    }
  }

}

// PUBLIC FACING LOAD BALANCER

resource "google_compute_global_forwarding_rule" "default" {
  name       = "lb"
  target     = "${google_compute_target_https_proxy.default.self_link}"
  port_range = "443"
}
