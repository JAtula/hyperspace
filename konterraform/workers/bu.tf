provider "google" {
  credentials = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/hyperspace-1dca531e62dc.json")}"
  project     = "hyperspace-171711"
  region      = "europe-west1"
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
  target_size        = 1
}

resource "google_compute_instance_template" "worker-node" {
  name         = "kontena-test"
  machine_type = "g1-small"

  network_interface {
    network = "default"
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
    KONTENA_VERSION = "1.3"
    KONTENA_URI="https://kontena-master"
    KONTENA_TOKEN="dItWdyRlCAZIkV+r2+qxcxjACtNFbkR4Lz8g/aX6JHXgYMNR1H+e6toa35L4DHIpAYadV3Jz3+kDzmmle3381w=="
    KONTENA_PEER_INTERFACE="eth1"
   
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

}