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
          // Ephemeral IP
      }
  }
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
    name = "kontena-master-fwr"
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
