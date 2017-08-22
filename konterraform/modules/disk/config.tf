variable "disk_name" {
    description = "Disk name"
}

variable "disk_size" {
    description = "Disk size"
    default = "10"
}

variable "disk_type" {
    description = "Disk type"
    default = "pd-ssd"
}

variable "disk_zone" {
    description = "Disk zone"
}
