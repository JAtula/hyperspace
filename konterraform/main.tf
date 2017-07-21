// Copyright 2017 Google Inc. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

provider "google" {
  credentials = ""
  project      = "modern-girder-157718"
  region       = "us-central1"
}

//
// MASTER INSTANCES
//

resource "google_compute_instance" "kontena-master" {
  name         = "${format("kontena-master", count.index)}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"
  tags         = ["kontena-master"]

  disk {
    source_image = "coreos-stable-1409-5-0-v20170623"
    auto_delete  = true
    boot         = true
  }

  network_interface {
      network = "default"
      access_config {
          // Ephemeral IP
      }
  }
  count = 3
  lifecycle = {
    create_before_destroy = true
  }
  metadata  {
    user-data="${data.template_file.cloud_config.rendered}"
  }
}

//
// WORKER NODES
//

/*
resource "google_compute_instance_template" "kontena_node" {
  name_prefix  = "kontena-node"
  machine_type = "g1-small"
  region       = "europe-west1"

  // boot disk
  disk {
    source_image = "coreos-stable-1409-5-0-v20170623"
    auto_delete  = true
    boot         = true
  }

  // networking
  network_interface {
    network = "default"
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata  {
    user-data="${data.template_file.cloud_config_nodes.rendered}"
  }
}


resource "google_compute_instance_group_manager" "kontena_node_manager" {
  name               = "kontena-node-group-manager"
  instance_template  = "${google_compute_instance_template.kontena_node.self_link}"
  base_instance_name = "kontena-node"
  zone               = "europe-west1-b"
  target_size        = "6"


}

data "template_file" "cloud_config_nodes" {

    template = "${file("cloud-config-node.yaml.tpl")}"   
}
*/

//
// NETWORKING
//
resource "google_compute_firewall" "fwrule" {
    name = "hyperspace-web"
    network = "default"
    allow {
        protocol = "tcp"
        ports    = ["22","80", "443", "9292"]
    }
    target_tags = ["kontena-master"]
}

resource "google_compute_forwarding_rule" "fwd_rule" {
    name = "fwdrule"
    target = "${google_compute_target_pool.tpool.self_link}"
    port_range = "443"
}

resource "google_compute_target_pool" "tpool" {
    name = "tpool"
    instances = [
        "${google_compute_instance.kontena-master.self_link}"
    ]
}

resource "google_compute_ssl_certificate" "master-cert" {
  name        = "ha-certs"
  description = "Certificates for master"
  private_key = "${file("private.key")}"
  certificate = "${file("cert.crt")}"
}

resource "google_compute_target_https_proxy" "kontena-master-proxy" {
  name        = "kontena-master-proxy"
  description = "A proxy for incoming connections to Kontena master"
  url_map     = "${google_compute_url_map.kontena-master-url.self_link}"
   ssl_certificates = ["${google_compute_ssl_certificate.master-cert.self_link}"]
}

resource "google_compute_url_map" "kontena-master-url" {
  name            = "kontena-master"
  description     = "An URL map for Kontena master"
  default_service = "${google_compute_instance.kontena-master.self_link}"

  host_rule {
    hosts        = ["kontena-master"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_instance.kontena-master.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_instance.kontena-master.self_link}"
    }
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
    MONGODB_URI = "mongodb://mongoadmin:Perse500@mongodb-1:10481,mongodb-2:10481/kontena-master?replicaSet=kontena-master"
    RACK_ENV = "production"
  }
    
}

output "lb_ip" {
  value = "${google_compute_forwarding_rule.fwd_rule.ip_address}"
}
