variable "template_file_workers" {
    description = "Workers template file location"
}

variable "kontena_version" {
    description = "Kontena version"
    default     = "1.3"
}

variable "kontena_uri" {
    description = "Endpoint for workers to connect to"
}

variable "kontena_peer_interface" {
    description = "Node interface to use"
    default     = "ens4v1"
}

variable "kontena_worker_token" {
    description = "Kontena token"
}

variable "auth_file" {
    description = "The configuration file containing the credentials to connect to google"
}

variable "project" {
    description = "The project in Google Cloud to create the GitLab instance under"
}

variable "image" {
    description = "Image for worker instances"
    default = "coreos-stable-1409-7-0-v20170719"
}

variable "region" {
    description = "The region this all lives in. TODO can this be inferred from zone or vice versa?"
    default = "us-central1"
}

variable "zone" {
    description = "The zone to deploy the machine to"
    default = "us-central1-a"
}

variable "private_key" {
    description = "The SSL keyfile to use"
    default = "/dev/null"
}

variable "private_crt" {
    description = "The SSL certificate file to use"
    default = "/dev/null"
}

variable "ssh_key" {
    description = "The public ssh key to use to connect to the Google Cloud Instance"
    default = "~/.ssh/id_rsa.pub"
}

variable "network" {
    description = "The network for the instance to live on"
    default = "default"
}

