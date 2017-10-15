variable "auth_file" {
    description = "The configuration file containing the credentials to connect to google"
}

variable "name" {
    description = "Disk name"
}

variable "size" {
    description = "Disk size"
    default = "10"
}

variable "type" {
    description = "Disk type"
    default = "pd-ssd"
}

variable "zone" {
    description = "Disk zone"
}

variable "region" {
    description = "Disk region"
}

variable "project" {
    description = "Project to use"
}
