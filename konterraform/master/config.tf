variable "template_file" {
    description = "Master template file location"
}

variable "kontena_version" {
    description = "Kontena version"
    default     = "1.3"
}

variable "kontena_vault_key" {
    description = "Random string, like: cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1"
}

variable "kontena_vault_iv" {
    description = "Random string, like: cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1"
}

variable "kontena_initial_admin_code" {
    description = "Initial admin code to connect to master API"
}

//variable "kontena_grid_size" {
//    description = "Initial grid size"
//    default     = "3"
//}

variable "kontena_token" {
    description = "Kontena token"
}

