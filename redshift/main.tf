resource "aws_redshift_cluster" "default" {
  cluster_identifier = var.cluster_identifier == "" ? lower("${var.name}-cluster") : lower(var.cluster_identifier)
  database_name      = var.database_name
  master_username    = var.admin_user
  master_password    = var.admin_password
  node_type          = var.node_type
  cluster_type       = var.cluster_type

  vpc_security_group_ids       = module.redshift_sg.id
  cluster_subnet_group_name    = aws_redshift_subnet_group.default.id
  availability_zone            = var.availability_zone
  preferred_maintenance_window = var.preferred_maintenance_window

  cluster_parameter_group_name        = aws_redshift_parameter_group.default.id
  automated_snapshot_retention_period = var.automated_snapshot_retention_period
  port                                = var.port
  cluster_version                     = var.engine_version
  number_of_nodes                     = var.nodes
  publicly_accessible                 = var.publicly_accessible
  encrypted                           = var.encrypted
  enhanced_vpc_routing                = var.enhanced_vpc_routing
  kms_key_id                          = var.kms_key_arn
  elastic_ip                          = var.elastic_ip
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = var.final_snapshot_identifier
  snapshot_identifier                 = var.snapshot_identifier
  snapshot_cluster_identifier         = var.snapshot_cluster_identifier
  owner_account                       = var.owner_account
  iam_roles                           = var.iam_roles

  depends_on = [
    aws_redshift_subnet_group.default,
    aws_redshift_parameter_group.default
  ]

  logging {
    enable        = var.logging
    bucket_name   = var.logging_bucket_name
    s3_key_prefix = var.logging_s3_key_prefix
  }

  tags = var.tags
}

resource "aws_redshift_subnet_group" "default" {
  name        = lower("${var.name}-subnetgroup")
  subnet_ids  = var.subnet_ids
  description = "Allowed subnets for Redshift Subnet group"
  tags        = var.tags
}

resource "aws_redshift_parameter_group" "default" {
  name   = lower("${var.name}-paramgroup")
  family = "redshift-1.0"

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

module "redshift_sg" {
  source             = "../vpc/aws_security_group"
  tags               = var.tags
  name               = "${var.name}-redshift-sg"
  description        = "${var.name}-redshift-sg"
  vpc_id             = var.vpc_id
  sg_ingress_rules   = var.ingress_sgs
  cidr_ingress_rules = var.ingress_cidrs
  port               = var.port
  protocol           = "tcp"
}
