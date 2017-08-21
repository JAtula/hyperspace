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
// DISK for GitLab
//

resource "google_compute_disk" "gitlab-disk" {
  name  = "${var.disk_name}"
  type  = "${var.disk_type}"
  zone  = "${var.disk_zone}"
  size  = "${var.disk_size}"
}

output "disk_name" {
  value = "${google_compute_disk.gitlab-disk.name}"
}
