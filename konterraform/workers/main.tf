provider "google" {
  credentials = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/hyperspace-1dca531e62dc.json")}"
  project     = "hyperspace-171711"
  region      = "europe-west1"
}

//
// MASTER INSTANCES
//

resource "google_compute_instance" "kontena-node" {
  name         = "${format("kontena-node-%d", count.index)}"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-b"
  tags         = ["kontena-node"]

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
    user-data="${data.template_file.cloud_config_nodes.rendered}"
  }
}


data "template_file" "cloud_config_nodes" {

    template = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/cloud-config-node.yaml.tpl")}"

  vars {
    KONTENA_VERSION = "1.3"
    KONTENA_URI="https://kontena-master"
    KONTENA_TOKEN="dItWdyRlCAZIkV+r2+qxcxjACtNFbkR4Lz8g/aX6JHXgYMNR1H+e6toa35L4DHIpAYadV3Jz3+kDzmmle3381w=="
    KONTENA_PEER_INTERFACE="eth1"
   
   }
    
}