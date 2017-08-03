provider "google" {
  credentials = "${file("/Users/juhaniatula/Documents/dev/hyperspace/konterraform/konterraform-f36234d1ed7d.json")}"
  project     = "konterraform"
  region      = "europe-west1"
}


// WORKER NODES

resource "google_compute_backend_service" "worker-node" {
  name        = "worker-node"
  description = "Worker nodes backend service"
  port_name   = "https"
  protocol    = "HTTPS"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group_manager.workers.instance_group}"
  }

  health_checks = ["${google_compute_https_health_check.default.self_link}"]
}

resource "google_compute_instance_group_manager" "workers" {
  name               = "kontena-test"
  instance_template  = "${google_compute_instance_template.worker-node.self_link}"
  base_instance_name = "worker-node"
  zone               = "europe-west1-b"
  target_size        = 3
  
  named_port {
    name = "https"
    port = 443
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

resource "google_compute_https_health_check" "default" {
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

}

// PUBLIC FACING LOAD BALANCER

resource "google_compute_global_forwarding_rule" "default" {
  name       = "lb"
  target     = "${google_compute_target_https_proxy.default.self_link}"
  port_range = "443"
}

resource "google_compute_firewall" "fwrule" {
    name = "kontena-workers-fwr"
    network = "default"
    allow {
        protocol = "tcp"
        ports = ["80","443","22"]
    }
}

//output "worker_lb_access" {
//  value = "${google_compute_target_https_proxy.default.}"
//}