resource "aws_security_group" "default" {
  count       = var.enabled == "true" ? 1 : 0
  name        = "${var.name}-sg"
  description = "Allow inbound traffic from Security Groups and CIDRs"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_rds_cluster" "default" {
  count                               = var.enabled == "true" ? 1 : 0
  cluster_identifier                  = var.name
  database_name                       = var.db_name
  master_username                     = var.admin_user
  master_password                     = var.admin_password
  backup_retention_period             = var.retention_period
  preferred_backup_window             = var.backup_window
  final_snapshot_identifier           = var.final_snapshot_identifier == "" ? lower(var.name) : var.final_snapshot_identifier
  skip_final_snapshot                 = var.skip_final_snapshot
  apply_immediately                   = var.apply_immediately
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_arn
  snapshot_identifier                 = var.snapshot_identifier
  vpc_security_group_ids              = concat([aws_security_group.default[0].id], var.extra_sgs)
  preferred_maintenance_window        = var.maintenance_window
  db_subnet_group_name                = aws_db_subnet_group.default[count.index].name
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.default[count.index].name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  tags                                = var.tags
  engine                              = var.engine
  engine_version                      = var.engine_version
  engine_mode                         = var.engine_mode
  replication_source_identifier       = var.replication_source_identifier
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  deletion_protection                 = var.deletion_protection
  availability_zones                  = var.availability_zones
  #scaling_configuration               = var.scaling_configuration

  lifecycle {
    ignore_changes = [
      availability_zones
    ]
  }
}

locals {
  min_instance_count     = var.autoscaling_enabled == "true" ? var.autoscaling_min_capacity : var.cluster_size
  cluster_instance_count = var.enabled == "true" ? local.min_instance_count : 0
}

resource "aws_rds_cluster_instance" "default" {
  count                           = local.cluster_instance_count
  identifier                      = "${var.name}-${count.index + 1}"
  cluster_identifier              = join("", aws_rds_cluster.default.*.id)
  instance_class                  = var.instance_type
  db_subnet_group_name            = aws_db_subnet_group.default[0].name
  db_parameter_group_name         = aws_db_parameter_group.default[0].name
  publicly_accessible             = var.publicly_accessible
  tags                            = var.tags
  engine                          = var.engine
  engine_version                  = var.engine_version
  monitoring_interval             = var.rds_monitoring_interval
  monitoring_role_arn             = var.rds_monitoring_role_arn
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  availability_zone               = var.instance_availability_zone
}

resource "aws_db_subnet_group" "default" {
  count       = var.enabled == "true" ? 1 : 0
  name        = "${var.name}-subnet-group"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnets
  tags        = var.tags
}

resource "aws_rds_cluster_parameter_group" "default" {
  count       = var.enabled == "true" ? 1 : 0
  name        = "${var.name}-clusterpgroup"
  description = "DB cluster parameter group"
  family      = var.cluster_family
  #[ for param in var.cluster_parameters : ]
  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }
  tags = var.tags
}

resource "aws_db_parameter_group" "default" {
  count       = var.enabled == "true" ? 1 : 0
  name        = "${var.name}-dbpgroup"
  description = "DB instance parameter group"
  family      = var.cluster_family
  dynamic "parameter" {
    for_each = var.instance_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }
  tags = var.tags
}

resource "aws_appautoscaling_target" "replicas" {
  count              = var.enabled == "true" && var.autoscaling_enabled == "true" ? 1 : 0
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${aws_rds_cluster.default[count.index].id}"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "replicas" {
  count              = var.enabled == "true" && var.autoscaling_enabled == "true" ? 1 : 0
  name               = "${var.name}-as-policy"
  service_namespace  = join("", aws_appautoscaling_target.replicas.*.service_namespace)
  scalable_dimension = join("", aws_appautoscaling_target.replicas.*.scalable_dimension)
  resource_id        = join("", aws_appautoscaling_target.replicas.*.resource_id)
  policy_type        = var.autoscaling_policy_type

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.autoscaling_target_metrics
    }

    disable_scale_in   = false
    target_value       = var.autoscaling_target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}
