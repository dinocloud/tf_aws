## Stack
resource "aws_opsworks_stack" "stack" {
  name                          = local.stack.name
  region                        = var.region
  service_role_arn              = local.stack.service_role_arn
  default_instance_profile_arn  = local.stack.default_instance_profile_arn
  agent_version                 = local.stack.agent_version
  berkshelf_version             = local.stack.berkshelf_version
  color                         = local.stack.color
  default_availability_zone     = local.stack.default_availability_zone
  configuration_manager_name    = local.stack.configuration_manager_name
  configuration_manager_version = local.stack.configuration_manager_version

  dynamic "custom_cookbooks_source" {
    for_each = length(local.stack.custom_cookbooks_source) == 0 ? [] : [local.stack.custom_cookbooks_source]
    content {
      type     = custom_cookbooks_source.value.type
      url      = custom_cookbooks_source.value.url
      username = lookup(custom_cookbooks_source, "username", null)
      password = lookup(custom_cookbooks_source, "password", null)
      ssh_key  = lookup(custom_cookbooks_source, "ssh_key", null)
    }
  }

  default_os                   = local.stack.default_os
  default_root_device_type     = local.stack.default_root_device_type
  default_ssh_key_name         = local.stack.default_ssh_key_name
  default_subnet_id            = var.vpc_id == "" ? "" : local.stack.default_subnet_id
  hostname_theme               = local.stack.hostname_theme
  manage_berkshelf             = local.stack.berkshelf_version != ""
  tags                         = var.tags
  use_custom_cookbooks         = local.stack.custom_cookbooks_source != ""
  use_opsworks_security_groups = local.stack.use_opsworks_security_groups
  vpc_id                       = var.vpc_id
  custom_json                  = local.stack.custom_json
}

## Layers
resource "aws_opsworks_custom_layer" "layer" {
  for_each                    = local.layers
  name                        = each.key
  short_name                  = each.value["short_name"]
  stack_id                    = aws_opsworks_stack.stack.id
  auto_assign_elastic_ips     = each.value.auto_assign_elastic_ips
  auto_assign_public_ips      = each.value.auto_assign_public_ips
  custom_instance_profile_arn = each.value.custom_instance_profile_arn
  custom_security_group_ids   = each.value.custom_security_group_ids
  auto_healing                = each.value.auto_healing
  install_updates_on_boot     = each.value.install_updates_on_boot
  instance_shutdown_timeout   = each.value.instance_shutdown_timeout
  elastic_load_balancer       = each.value.elastic_load_balancer
  drain_elb_on_shutdown       = each.value.drain_elb_on_shutdown
  system_packages             = each.value.system_packages
  use_ebs_optimized_instances = each.value.use_ebs_optimized_instances
  custom_json                 = each.value.custom_json
  tags                        = var.tags
  custom_configure_recipes    = each.value.custom_configure_recipes
  custom_deploy_recipes       = each.value.custom_deploy_recipes
  custom_setup_recipes        = each.value.custom_setup_recipes
  custom_shutdown_recipes     = each.value.custom_shutdown_recipes
  custom_undeploy_recipes     = each.value.custom_undeploy_recipes

  dynamic "ebs_volume" {
    for_each = lookup(each.value, "ebs_volume", {})
    content {
      mount_point     = ebs_volume.mount_point
      size            = ebs_volume.size
      number_of_disks = ebs_volume.number_of_disks
      raid_level      = ebs_volume.raid_level
      type            = lookup(ebs_volume, "type", null)
      iops            = lookup(ebs_volume, "iops", null)
      encrypted       = lookup(ebs_volume, "encrypted", null)
    }
  }
}

##Instances
resource "aws_opsworks_instance" "instances" {
  for_each      = local.instances
  instance_type = each.value.instance_type
  stack_id      = aws_opsworks_stack.stack.id
  layer_ids = [for l in each.value.layers :
    aws_opsworks_custom_layer.layer[l].id
  ]
  state                   = each.value.state
  install_updates_on_boot = each.value.install_updates_on_boot
  auto_scaling_type       = each.value.auto_scaling_type
  availability_zone       = each.value.availability_zone
  ebs_optimized           = each.value.ebs_optimized
  hostname                = each.value.hostname
  architecture            = each.value.architecture
  ami_id                  = each.value.ami_id
  os                      = each.value.ami_id != "" ? "" : each.value.os
  root_device_type        = each.value.root_device_type
  ssh_key_name            = each.value.ssh_key_name
  agent_version           = each.value.agent_version
  subnet_id               = each.value.subnet_id
  tenancy                 = each.value.tenancy
  virtualization_type     = each.value.virtualization_type

  dynamic "root_block_device" {
    for_each = lookup(each.value, "root_block_device", {})
    content {
      volume_type           = lookup(root_block_device, "volume_type", null)
      volume_size           = lookup(root_block_device, "volume_size", null)
      iops                  = lookup(root_block_device, "iops", null)
      delete_on_termination = lookup(root_block_device, "delete_on_termination", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = lookup(each.value, "ebs_block_device", {})
    content {
      device_name           = ebs_block_device.device_name
      snapshot_id           = lookup(ebs_block_device, "snapshot_id", null)
      volume_type           = lookup(ebs_block_device, "volume_type", null)
      volume_size           = lookup(ebs_block_device, "volume_size", null)
      iops                  = lookup(ebs_block_device, "iops", null)
      delete_on_termination = lookup(ebs_block_device, "delete_on_termination", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = lookup(each.value, "ephemeral_block_device", {})
    content {
      device_name  = ephemeral_block_device.device_name
      virtual_name = ephemeral_block_device.virtual_name
    }
  }
}

#Apps
resource "aws_opsworks_application" "app" {
  for_each                  = local.apps
  name                      = each.key
  short_name                = each.value.short_name
  stack_id                  = aws_opsworks_stack.stack.id
  type                      = each.value.type
  description               = each.value.description
  enable_ssl                = each.value.enable_ssl
  data_source_arn           = each.value.data_source_arn
  data_source_type          = each.value.data_source_type
  data_source_database_name = each.value.data_source_database_name
  domains                   = each.value.domains
  document_root             = each.value.document_root
  auto_bundle_on_deploy     = each.value.auto_bundle_on_deploy
  aws_flow_ruby_settings    = each.value.aws_flow_ruby_settings

  rails_env = each.value.type != "rails" ? "" : each.value.rails_env

  dynamic "app_source" {
    for_each = length(lookup(each.value, "app_source", {})) == 0 ? [] : [1]
    content {
      type     = each.value.app_source.type
      url      = each.value.app_source.url
      username = lookup(each.value.app_source, "username", null)
      password = lookup(each.value.app_source, "password", null)
      ssh_key  = lookup(each.value.app_source, "ssh_key", null)
      revision = lookup(each.value.app_source, "revision", null)
    }
  }

  dynamic "environment" {
    for_each = each.value.environment
    content {
      key    = environment.key
      value  = environment.value
      secure = lookup(environment, "secure", null)
    }
  }

  dynamic "ssl_configuration" {
    for_each = each.value.ssl_configuration
    content {
      private_key = ssl_configuration.private_key
      certificate = ssl_configuration.certificate
      chain       = lookup(chain, "chain", null)
    }
  }
}

## Aivoco Route 53 Records
resource "aws_route53_record" "aivoco_public" {
  for_each = zipmap([], var.aivoco_hostnames)
  zone_id  = var.hosted_zones["aivoco"].public_hz_id
  name     = each.value
  type     = "A"
  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = var.environment
}

resource "aws_route53_record" "aivoco_priv" {
  for_each = zipmap([], var.aivoco_hostnames)
  zone_id  = var.hosted_zones["aivoco"].private_hz_id
  name     = each.value
  type     = "A"
  alias {
    name                   = aws_lb.internal.dns_name
    zone_id                = aws_lb.internal.zone_id
    evaluate_target_health = true
  }
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = var.environment
}

## Agentbot Route 53 Records
resource "aws_route53_record" "agentbot_public" {
  for_each = zipmap([], var.agentbot_hostnames)
  zone_id  = var.hosted_zones["agentbot"].public_hz_id
  name     = each.value
  type     = "A"
  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = var.environment
}

resource "aws_route53_record" "agentbot_priv" {
  for_each = zipmap([], var.agentbot_hostnames)
  zone_id  = var.hosted_zones["agentbot"].private_hz_id
  name     = each.value
  type     = "A"
  alias {
    name                   = aws_lb.internal.dns_name
    zone_id                = aws_lb.internal.zone_id
    evaluate_target_health = true
  }
  weighted_routing_policy {
    weight = 1
  }
  set_identifier = var.environment
}