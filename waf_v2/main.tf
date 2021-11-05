locals {
  regex_rules = { for k, v in local.rules : k => v if v.regex_pattern_statement != {} }
  ipset_rules = { for k, v in local.rules : k => v if v.ip_set_reference_statement != {} }
}

#### RegEx Pattern Set
resource "aws_wafv2_regex_pattern_set" "regex_set" {
  for_each    = { for k, v in local.regex_rules : k => v if lookup(v.regex_pattern_statement, "regex_set_arn", 0) == 0 }
  name        = each.key
  description = "${each.key} regex pattern set"
  scope       = var.scope
  tags        = var.tags

  dynamic "regular_expression" {
    for_each = toset(each.value.regex_pattern_statement.regex_strings)
    content {
      regex_string = regular_expression.key
    }
  }
}

# #### IPSet
# resource "aws_wafv2_ip_set" "example" {
#   name               = "example"
#   description        = "Example IP set"
#   scope              = "REGIONAL"
#   ip_address_version = "IPV4"
#   addresses          = ["1.2.3.4/32", "5.6.7.8/32"]

#   tags = {
#     Tag1 = "Value1"
#     Tag2 = "Value2"
#   }
# }
# name - (Required) A friendly name of the IP set.
# description - (Optional) A friendly description of the IP set.
# scope - (Required) Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the Region US East (N. Virginia).
# ip_address_version - (Required) Specify IPV4 or IPV6. Valid values are IPV4 or IPV6.
# addresses - (Required) Contains an array of strings that specify one or more IP addresses or blocks of IP addresses in Classless Inter-Domain Routing (CIDR) notation. AWS WAF supports all address ranges for IP versions IPv4 and IPv6.
# tags - (Optional) An array of key:value pairs to associate with the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.


#### Logging
## TO DO ##Kinesis Stream?

#### ACL #########################################
resource "aws_wafv2_web_acl" "acl" {
  name        = "${lower(var.name)}-acl"
  description = var.description == "" ? "${lower(var.name)}-acl" : var.description
  scope       = var.scope
  tags        = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = lookup(var.visibility_config, "cw_metric", false) == true
    metric_name                = lookup(var.visibility_config, "cw_metric", "metric")
    sampled_requests_enabled   = lookup(var.visibility_config, "sampled_requests", false)
  }

  default_action {
    dynamic "allow" {
      for_each = var.default_allow ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_allow ? [] : [1]
      content {}
    }
  }

  dynamic "rule" {
    for_each = local.rules
    content {
      name     = rule.key
      priority = rule.value.priority

      # Action block is required for geo_match, ip_set, and ip_rate_based rules
      dynamic "action" {
        for_each = length(lookup(rule.value, "action", {})) == 0 ? [] : [1]
        content {
          dynamic "allow" {
            for_each = lookup(rule.value, "action", {}) == "allow" ? [1] : []
            content {}
          }

          dynamic "count" {
            for_each = lookup(rule.value, "action", {}) == "count" ? [1] : []
            content {}
          }

          dynamic "block" {
            for_each = lookup(rule.value, "action", {}) == "block" ? [1] : []
            content {}
          }
        }
      }

      # Only used for managed_rule_group_statements to override the default action
      dynamic "override_action" {
        for_each = length(lookup(rule.value, "override_action", {})) == 0 ? [] : [1]
        content {
          dynamic "none" {
            for_each = lookup(rule.value, "override_action", {}) == "none" ? [1] : []
            content {}
          }

          dynamic "count" {
            for_each = lookup(rule.value, "override_action", {}) == "count" ? [1] : []
            content {}
          }
        }
      }

      statement {
        dynamic "regex_pattern_set_reference_statement" {
          for_each = length(lookup(rule.value, "regex_pattern_statement", {})) == 0 ? [] : [lookup(rule.value, "regex_pattern_statement", {})]
          content {
            arn = lookup(regex_pattern_set_reference_statement, "regex_set_arn", aws_wafv2_regex_pattern_set.regex_set["${rule.key}"].arn)
            text_transformation {
              priority = lookup(regex_pattern_set_reference_statement.value.text_transformation, "priority", 0)
              type     = lookup(regex_pattern_set_reference_statement.value.text_transformation, "type", "NONE")
            }
            field_to_match {
              dynamic "uri_path" {
                for_each = length(lookup(regex_pattern_set_reference_statement.value.field_to_match, "uri_path", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "all_query_arguments" {
                for_each = length(lookup(regex_pattern_set_reference_statement.value.field_to_match, "all_query_arguments", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "body" {
                for_each = length(lookup(regex_pattern_set_reference_statement.value.field_to_match, "body", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "method" {
                for_each = length(lookup(regex_pattern_set_reference_statement.value.field_to_match, "method", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "query_string" {
                for_each = length(lookup(regex_pattern_set_reference_statement.value.field_to_match, "query_string", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "single_header" {
                for_each = length(lookup(regex_pattern_set_reference_statement.value.field_to_match, "single_header", {})) == 0 ? [] : [1]
                content {
                  name = lower(lookup(regex_pattern_set_reference_statement.value.field_to_match.single_header.value, "name"))
                }
              }
            }
          }
        }

        dynamic "managed_rule_group_statement" {
          for_each = length(lookup(rule.value, "managed_rule_group_statement", {})) == 0 ? [] : [lookup(rule.value, "managed_rule_group_statement", {})]
          content {
            name        = lookup(managed_rule_group_statement.value, "name")
            vendor_name = lookup(managed_rule_group_statement.value, "vendor_name", "AWS")

            dynamic "excluded_rule" {
              for_each = length(lookup(managed_rule_group_statement.value, "excluded_rule", {})) == 0 ? [] : toset(lookup(managed_rule_group_statement.value, "excluded_rule"))
              content {
                name = excluded_rule.value
              }
            }
          }
        }

        dynamic "byte_match_statement" {
          for_each = length(lookup(rule.value, "byte_match_statement", {})) == 0 ? [] : [lookup(rule.value, "byte_match_statement", {})]
          content {
            field_to_match {
              dynamic "uri_path" {
                for_each = length(lookup(byte_match_statement.value.field_to_match, "uri_path", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "all_query_arguments" {
                for_each = length(lookup(byte_match_statement.value.field_to_match, "all_query_arguments", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "body" {
                for_each = length(lookup(byte_match_statement.value.field_to_match, "body", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "method" {
                for_each = length(lookup(byte_match_statement.value.field_to_match, "method", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "query_string" {
                for_each = length(lookup(byte_match_statement.value.field_to_match, "query_string", {})) == 0 ? [] : [1]
                content {}
              }
              dynamic "single_header" {
                for_each = length(lookup(byte_match_statement.value.field_to_match, "single_header", {})) == 0 ? [] : [1]
                content {
                  name = lower(lookup(byte_match_statement.value.field_to_match.single_header, "name"))
                }
              }
            }
            positional_constraint = lookup(byte_match_statement.value, "positional_constraint")
            search_string         = lookup(byte_match_statement.value, "search_string")
            text_transformation {
              priority = lookup(byte_match_statement.value.text_transformation, "priority", 0)
              type     = lookup(byte_match_statement.value.text_transformation, "type", "NONE")
            }
          }
        }

        dynamic "geo_match_statement" {
          for_each = length(lookup(rule.value, "geo_match_statement", {})) == 0 ? [] : [lookup(rule.value, "geo_match_statement", {})]
          content {
            country_codes = lookup(geo_match_statement.value, "country_codes")
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = length(lookup(rule.value, "ip_set_reference_statement", {})) == 0 ? [] : [lookup(rule.value, "ip_set_reference_statement", {})]
          content {
            arn = lookup(ip_set_reference_statement.value, "arn")
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = lookup(rule.value.visibility_config, "cw_metric", false) != false
        metric_name                = lookup(rule.value.visibility_config, "cw_metric", "metric")
        sampled_requests_enabled   = lookup(rule.value.visibility_config, "sampled_requests", false)
      }
    }
  }

  depends_on = [
    aws_wafv2_regex_pattern_set.regex_set
  ]
}

#### Associations?
resource "aws_wafv2_web_acl_association" "this" {
  for_each     = toset(var.attached_resources)
  resource_arn = each.key
  web_acl_arn  = aws_wafv2_web_acl.acl.arn
}


### https://github.com/umotif-public/terraform-aws-waf-webaclv2