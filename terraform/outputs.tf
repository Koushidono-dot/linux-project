output "nodes" {
  description = "Provisioned node private and public network addresses."
  value = {
    for k, v in module.nodes : k => {
      private_ip = v.private_ip
      public_ip  = v.public_ip
    }
  }
}
