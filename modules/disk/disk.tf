provider "google" {
  credentials = "${file("${var.auth_file}")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

//
// DISK for GitLab
//

resource "google_compute_disk" "gitlab-disk" {
  name  = "${var.name}"
  type  = "${var.type}"
  zone  = "${var.zone}"
  size  = "${var.size}"
}