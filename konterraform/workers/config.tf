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