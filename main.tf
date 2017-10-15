  module "gitlab" {
    source = "modules/gitlab"
    auth_file = "cloud.json"
    project = "fatamigos-182411"
    region = "europe-west1"
    zone = "europe-west1-b"
    machine_type = "n1-standard-2"
    config_file = "conf/gitlab.rb"
    data_volume = "${module.disk.link}"
    dns_name = "gitlab.hypeisreal.com"
    prefix = "gitlab-"
    instance_name = "ce"
    internal_address = "10.132.0.2"
    ssl_certificate = "private.crt"
    ssl_key = "private.key"
    ssh_key = "~/.ssh/google_compute_engine"
  }

  module "runner" {
    source = "modules/runner"
    auth_file = "cloud.json"
    project = "fatamigos-182411"
    region = "europe-west1"
    zone = "europe-west1-b"
    dns_name = "gitlab.hypeisreal.com"
    prefix = "gitlab-"
    ssl_certificate = "crt"
    ssh_key = "~/.ssh/google_compute_engine"
    runner_token = "${module.gitlab.runner_token}"
    network = "${module.gitlab.network}"
    gitlab_ce_address = "${module.gitlab.internal_address}"
  }

module "disk" {
  source = "modules/disk"
  auth_file = "cloud.json"
  name  = "gitlab-data"
  type  = "pd-ssd"
  project = "fatamigos-182411"
  size = "30"
  zone  = "europe-west1-b"
  region = "europe-west1"
}

module "workers" {
  source  = "modules/workers"
  kontena_version = "1.3.4"
  kontena_uri = "<master uri>"
  kontena_worker_token = "<grid token>"
  kontena_peer_interface = "ens4v1"
  template_file_workers = "${file("modules/workers/cloud-config-node.yaml.tpl")}"
  private_crt = "private.crt"
  private_key = "private.key"
  ssh_key = "~/.ssh/google_compute_engine"
  auth_file = "cloud.json"
  project = "fatamigos-182411"
  zone  = "europe-west1-b"
  region = "europe-west1"
  image = "coreos-stable-1520-6-0-v20171012"
}
