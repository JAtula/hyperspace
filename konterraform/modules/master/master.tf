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

//  provisioner "file" {
//      source = "${var.ssl_certificate}"
//      destination = "/tmp/ssl_certificate"
// }

  provisioner "remote-exec" {
      inline = [
          "kontena grid create default --initial-size ${var.kontena_grid_size} --token $KONTENA_TOKEN"
      ]
    connection {
        type     = "ssh"
        user     = "core"
        private_key = "${file("~/.ssh/google_compute_engine")}"
    }
  }

}

//
// NETWORKING
//

/*resource "google_compute_firewall" "fwrule" {
    name = "kontena-fwr"
    network = "default"
    allow {
        protocol = "tcp"
        ports = ["80","443","22"]
    }

}*/


// PHERIPERALS

resource "random_id" "kontena_vault_key" {
    byte_length = 64
}

resource "random_id" "kontena_vault_iv" {
    byte_length = 64
}

resource "random_id" "kontena_token" {
    byte_length = 15
}

data "template_file" "cloud_config" {

    template = "${var.template_file}"

  vars {

    kontena_version = "${var.kontena_version}"
    kontena_vault_key = "${var.kontena_vault_key != "GENERATE" ? var.kontena_vault_key : format("%s", random_id.kontena_vault_key.hex)}"
    kontena_vault_iv = "${var.kontena_vault_iv != "GENERATE" ? var.kontena_vault_iv : format("%s", random_id.kontena_vault_iv.hex)}"
    kontena_token = "${var.kontena_token != "GENERATE" ? var.kontena_token : format("%s", random_id.kontena_token.hex)}"
    kontena_initial_admin_code = "${var.kontena_initial_admin_code}"
    kontena_grid_size = "${var.kontena_grid_size}"
  }
    
}

// OUTPUTS

output "kontena_version" {
    value = "${data.template_file.cloud_config.vars.kontena_version}"
}

output "kontena_vault_key" {
    value = "${data.template_file.cloud_config.vars.kontena_vault_key}"
}

output "kontena_vault_iv" {
    value = "${data.template_file.cloud_config.vars.kontena_vault_iv}"
}

output "kontena_token" {
    value = "${data.template_file.cloud_config.vars.kontena_token}"
}

output "master_ip" {
    value = "${google_compute_address.master-ip.address}"
}

output "master_name" {
    value = "${google_compute_instance.kontena-master.name}"
}
