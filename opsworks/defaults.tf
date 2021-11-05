locals {
  stack_defaults = {
    name                          = "${var.environment}-Stack"
    agent_version                 = "LATEST"
    service_role_arn              = ""
    default_instance_profile_arn  = ""
    berkshelf_version             = ""
    color                         = ""
    default_availability_zone     = ""
    configuration_manager_name    = "Chef"
    configuration_manager_version = "11.10"
    custom_cookbooks_source       = {}
    default_os                    = null
    default_root_device_type      = ""
    default_ssh_key_name          = ""
    default_subnet_id             = ""
    hostname_theme                = ""
    manage_berkshelf              = ""
    tags                          = ""
    use_opsworks_security_groups  = false
    custom_json                   = ""
  }

  layer_defaults = {
    auto_assign_elastic_ips     = "false"
    auto_assign_public_ips      = "false"
    custom_instance_profile_arn = null
    custom_security_group_ids   = []
    auto_healing                = "true"
    install_updates_on_boot     = "false"
    instance_shutdown_timeout   = "120"
    elastic_load_balancer       = null
    drain_elb_on_shutdown       = true
    system_packages             = null
    use_ebs_optimized_instances = "false"
    ebs_volume                  = {}
    custom_json                 = null
    tags                        = null
    custom_configure_recipes    = []
    custom_deploy_recipes       = []
    custom_setup_recipes        = []
    custom_shutdown_recipes     = []
    custom_undeploy_recipes     = []
  }

  instance_defaults = {
    state                   = "running"
    install_updates_on_boot = true
    auto_scaling_type       = "load"
    availability_zone       = null
    ebs_optimized           = false
    hostname                = null
    architecture            = "x86_64"
    ami_id                  = null
    os                      = null
    root_device_type        = "ebs"
    ssh_key_name            = null
    agent_version           = "INHERIT"
    subnet_id               = null
    tenancy                 = "default"
    virtualization_type     = "hvm"
    root_block_device       = {}
    ebs_block_device        = {}
    ephemeral_block_device  = {}
  }

  app_defaults = {
    short_name                = ""
    description               = null
    environment               = {}
    enable_ssl                = false
    ssl_configuration         = {}
    app_source                = {}
    data_source_arn           = null
    data_source_type          = null
    data_source_database_name = null
    domains                   = null
    document_root             = null
    auto_bundle_on_deploy     = null
    rails_env                 = null
    aws_flow_ruby_settings    = null
  }
}