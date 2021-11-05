locals {
  stack = merge(
    local.stack_defaults,
    var.stack
  )

  layers = { for k, v in var.layers : k => merge(
    local.layer_defaults,
    v
  ) }

  instances = { for k, v in var.instances : k => merge(
    local.instance_defaults,
    v
  ) }

  apps = { for k, v in var.applications : k => merge(
    local.app_defaults,
    v
  ) }
}
