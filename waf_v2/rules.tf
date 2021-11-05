locals {
  rule_defaults = {
    description                  = null
    priority                     = 100
    action                       = ""
    override_action              = ""
    visibility_config            = {}
    regex_pattern_statement      = {}
    byte_match_statement         = {}
    managed_rule_group_statement = {}
    geo_match_statement          = {}
    ip_set_reference_statement   = {}
  }

  rules = { for k, v in var.rules : k => merge(
    local.rule_defaults,
    v
  ) }
}