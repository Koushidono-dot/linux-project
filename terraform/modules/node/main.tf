resource "oci_core_instance" "node" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = var.hostname

  shape = "VM.Standard.E2.1.Micro"

  source_details {
    source_type             = "image"
    source_id               = var.image_id
    boot_volume_size_in_gbs = var.boot_volume_gb
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    hostname_label   = var.hostname
    private_ip       = var.ipv4_address
    assign_public_ip = var.assign_public_ip
  }

  metadata = {
    user_data = var.user_data
  }
}
