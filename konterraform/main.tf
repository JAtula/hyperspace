// Copyright 2017 Google Inc. All Rights Reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.


//
// KONTENA MASTER
//
module "master" {
  source  = "modules/master"
  kontena_version = "1.3"
  kontena_initial_admin_code = "Demo600"
  kontena_vault_key = "GENERATE"
  kontena_vault_iv  = "GENERATE"
//  kontena_token = "GENERATE"
//  kontena_grid_size = "3"
  template_file = "${file("${path.module}/modules/master/cloud-config.yaml.tpl")}"
}

//
// KONTENA WORKERS
//
module "workers"{
  source  = "modules/workers"
  kontena_version = "${module.master.kontena_version}"
  kontena_uri = "${module.master.master_name}.c.konterraform.internal"
//  kontena_worker_token = "${module.master.kontena_token}"
  kontena_worker_token = "asd123asd"
  kontena_peer_interface = "ens4v1"
  template_file_workers = "${file("${path.module}/modules/workers/cloud-config-node.yaml.tpl")}"

}

//
// GITLAB DISK
//
module "disk" {
  source  = "modules/disk"
  disk_name  = "gitlab-disk"
  disk_type  = "pd-ssd"
  disk_zone  = "europe-west1-b"
  disk_size  = "100"
}

//
// GITLAB
//
module "gitlab" {
  instance_name = "ce"
  source = "modules/gitlab"
  auth_file = "konterraform-f36234d1ed7d.json"
  project = "konterraform"
  region = "europe-west1"
  zone = "europe-west1-b"
  config_file = "/dev/null"
  data_volume = "${module.disk.disk_name}"
  prefix      = "gitlab-"
  dns_name    = "gitlab-ce.c.konterraform.internal"
  external_url = "https://gitlab.demo.io"
  runner_count = 1
  }

//
// GITLAB-RUNNER
//
module "gitlab-runner" {
  source = "modules/gitlab-runner"
  auth_file = "konterraform-f36234d1ed7d.json"
  project = "konterraform"
  region = "europe-west1"
  zone = "europe-west1-b"
  prefix      = "gitlab-"
  dns_name    = "${module.gitlab.gitlab_instance_name}.c.konterraform.internal"
  runner_count = 1
  runner_token = "${module.gitlab.runner_token}"
  }