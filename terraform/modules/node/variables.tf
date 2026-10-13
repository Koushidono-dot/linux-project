variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID."
}

variable "availability_domain" {
  type        = string
  description = "Target Availability Domain."
}

variable "subnet_id" {
  type        = string
  description = "Subnet OCID."
}

variable "hostname" {
  type        = string
  description = "Instance hostname."
}

variable "image_id" {
  type        = string
  description = "OCID of the OS image."
}

variable "ipv4_address" {
  type        = string
  description = "Fixed private IPv4 address."
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IPv4 address."
  default     = false
}

variable "ocpus" {
  type        = number
  description = "Number of OCPUs."
  default     = 1
}

variable "memory_in_gbs" {
  type        = number
  description = "RAM allocated in GB."
  default     = 4
}

variable "boot_volume_gb" {
  type        = number
  description = "Boot volume size in GB."
  default     = 50
}

variable "user_data" {
  type        = string
  description = "Base64 encoded cloud-init configuration."
}
