locals {
  ssh_public_key = file(var.ssh_public_key_path)
}

module "nodes" {
  source   = "./modules/node"
  for_each = var.node_instances

  compartment_ocid    = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  subnet_id           = oci_core_subnet.nodes_subnet.id
  hostname            = each.value.hostname
  ipv4_address        = each.value.ipv4_address
  assign_public_ip    = each.value.assign_public
  boot_volume_gb      = each.value.boot_volume_gb

  image_id = each.value.os_family == "ubuntu" ? data.oci_core_images.ubuntu.images[0].id : data.oci_core_images.rhel_family.images[0].id

  user_data = base64encode(templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    hostname       = each.value.hostname
    ssh_public_key = local.ssh_public_key
  }))
}
