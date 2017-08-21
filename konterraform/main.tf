// Copyright 2017 Google Inc. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.


//
// KONTENA MASTER
//
module "master" {
  source  = "./master"
  kontena_version = "1.3"
  kontena_initial_admin_code = "Demo600"
  kontena_vault_key = "GENERATE"
  kontena_vault_iv  = "GENERATE"
  kontena_token = "GENERATE"
//  kontena_grid_size = "3"
  template_file = "${file("${path.module}/master/cloud-config.yaml.tpl")}"
}

//
// KONTENA WORKERS
//
module "workers"{
  source  = "./workers"
  kontena_version = "${module.master.kontena_version}"
  kontena_uri = "https://10.132.0.2"
  kontena_worker_token = "${module.master.kontena_token}"
  kontena_peer_interface = "ens4v1"
  template_file_workers = "${file("${path.module}/workers/cloud-config-node.yaml.tpl")}"

}

//
// GITLAB DISK
//
module "disk" {
  source  = "./disk"
  disk_name  = "gitlab-disk"
  disk_type  = "pd-ssd"
  disk_zone  = "europe-west1-b"
  disk_size  = "100"
}

//
// GITLAB
//
module "gitlab" {
  source = "./gitlab"
  auth_file = "konterraform-f36234d1ed7d.json"
  project = "konterraform"
  region = "europe-west1"
  zone = "europe-west1-b"
  config_file = "/dev/null"
  data_volume = "${module.disk.disk_name}"
  prefix      = "gitlab"
  dns_name    = "http://localhost"
  external_url = "https://gitlab.demo.io"
  ssl_key     = "private.key"
  ssl_certificate = "public.crt"
  runner_count = 1
  }
