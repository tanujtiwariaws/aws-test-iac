locals {
  # Using coalesce to handle null cases, if no custom ingress rules are defined
  build_custom_ingress_rules = coalesce(var.build_custom_ingress[var.env]["ingress"], {})

  # Using coalesce to handle null cases, if no custom egress rules are defined
  build_custom_egress_rules = coalesce(var.build_custom_egress[var.env]["egress"], {})
}
