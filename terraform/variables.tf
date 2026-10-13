variable "tenancy_ocid" {
  type        = string
  description = "OCID of the OCI tenancy."
}

variable "user_ocid" {
  type        = string
  description = "OCID of the OCI user executing Terraform."
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint for the OCI API signing key."
}

variable "private_key_path" {
  type        = string
  description = "Local filesystem path to the OCI API private key."
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  type        = string
  description = "OCI region identifier."
  default     = "eu-stockholm-1"
}

variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment where resources will be provisioned."
}

variable "ssh_public_key_path" {
  type        = string
  description = "Filesystem path to the public key injected into the admin user via cloud-init."
  default     = "~/.ssh/challenge_admin.pub"
}

variable "mgmt_cidr" {
  type        = string
  description = "The single external IPv4 CIDR range permitted to access bastion SSH."
  default     = "0.0.0.0/0"

  # Validation Block 1 (FR-03)
  validation {
    condition     = can(cidrhost(var.mgmt_cidr, 0))
    error_message = "mgmt_cidr must be a valid IPv4 CIDR notation (e.g. '203.0.113.50/32' or '0.0.0.0/0')."
  }
}

variable "node_instances" {
  type = map(object({
    hostname       = string
    os_family      = string
    ipv4_address   = string
    assign_public  = bool
    ocpus          = number
    memory_in_gbs  = number
    boot_volume_gb = number
  }))
  description = "Map of node definitions iterated via for_each."
  default = {
    bastion = {
      hostname       = "bastion-01"
      os_family      = "ubuntu"
      ipv4_address   = "10.30.1.10"
      assign_public  = true
      ocpus          = 1
      memory_in_gbs  = 4
      boot_volume_gb = 50
    },
    app = {
      hostname       = "app-01"
      os_family      = "rocky"
      ipv4_address   = "10.30.2.10"
      assign_public  = true
      ocpus          = 1
      memory_in_gbs  = 4
      boot_volume_gb = 50
    }
  }

  # Validation Block 2 (FR-03 & Section 2 Constraints)
  validation {
    condition = alltrue([
      for k, v in var.node_instances : contains(["ubuntu", "rocky"], v.os_family)
    ])
    error_message = "Every node os_family must be strictly 'ubuntu' or 'rocky'."
  }
}
