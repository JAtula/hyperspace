// Copyright 2017 Google Inc. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

provider "google" {
    credentials = "${file("${var.auth_file}")}"
    project = "${var.project}"
    region = "${var.region}"
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
  name               = "kontena-workers"
  instance_template  = "${google_compute_instance_template.worker-node.self_link}"
  base_instance_name = "worker-node"
  zone               = "${var.zone}"
  target_size        = 3
  
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "scaler"
  zone   = "${var.zone}"
  target = "${google_compute_instance_group_manager.workers.self_link}"

  autoscaling_policy = {
    max_replicas    = 6
    min_replicas    = 3
    cooldown_period = 300

    cpu_utilization {
      target = 0.8
    }
  }
}


resource "google_compute_instance_template" "worker-node" {
  name         = "kontena-test"
  machine_type = "g1-small"

  network_interface {
    network = "${var.network}"
    access_config {
      // Dynamic IP
    }
  }

  disk {
    source_image = "${var.image}"
    auto_delete  = true
    type         = "pd-ssd"
  }
  metadata  {
    user-data="${data.template_file.cloud_config_nodes.rendered}"
    sshKeys = "core:${file("${var.ssh_key}.pub")}"
  }

}

resource "google_compute_http_health_check" "default" {
  name               = "test"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

data "template_file" "cloud_config_nodes" {

    template = "${var.template_file_workers}"

  vars {

    kontena_version = "${var.kontena_version}"
    kontena_uri = "${var.kontena_uri}"
    kontena_worker_token = "${var.kontena_worker_token}"
    kontena_peer_interface = "${var.kontena_peer_interface}"
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
  name        = "ssl-certificate"
  description = "SSL certificate for LB"
  private_key = "${file(var.private_key)}"
  certificate = "${file(var.private_crt)}"
}

resource "google_compute_url_map" "default" {
  name        = "url-map"
  description = "URL map for LB"

  default_service = "${google_compute_backend_service.worker-node.self_link}"

  host_rule {
    hosts        = ["app.hypeisreal.com"]
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
