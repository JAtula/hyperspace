// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("hyperspace-1dca531e62dc.json")}"
  project     = "hyperspace-171711"
  region      = "eu-west1"
}

resource "google_compute_instance" "coreos" {
  name = "${format("coreos-%d", count.index)}"
  image = "cos-stable-59-9460-64-0"
  private_networking = true
  zone = "europe-west1-b"
  machine_type = "n1-standard-1"

  metadata  {

    user-data="${data.template_file.cloud_config.rendered}"
  }

}

data "template_file" "cloud_config" {

    template = "${file("cloud-config.yaml.tpl")}"
    
}


output "address_coreos" {
  value = "${google_compute_instance.coreos.ipv4_address}"
}

