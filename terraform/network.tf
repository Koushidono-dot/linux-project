resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_ocid
  display_name   = "challenge-vcn"
  cidr_blocks    = ["10.30.0.0/16"]
  dns_label      = "challengenet"
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "challenge-igw"
  enabled        = true
}

resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "challenge-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_security_list" "allow_all_internal" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "challenge-security-list"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  ingress_security_rules {
    protocol  = "6" # TCP
    source    = var.mgmt_cidr
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol  = "6"
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol  = "all"
    source    = "10.30.0.0/16"
    stateless = false
  }

  ingress_security_rules {
    protocol  = "1" # ICMP
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol  = "1"
    source    = "0.0.0.0/0"
    stateless = false

    icmp_options {
      type = 8
    }
  }
}

resource "oci_core_subnet" "nodes_subnet" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.main.id
  cidr_block        = "10.30.0.0/16"
  display_name      = "challenge-subnet"
  dns_label         = "nodes"
  route_table_id    = oci_core_route_table.public_rt.id
  security_list_ids = [oci_core_security_list.allow_all_internal.id]
}
