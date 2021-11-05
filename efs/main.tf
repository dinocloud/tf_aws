locals {
  enabled  = var.enabled == "true"
  dns_name = "${join("", aws_efs_file_system.main.*.id)}.efs.${var.region}.amazonaws.com"
}

resource "aws_efs_file_system" "main" {
  count                           = local.enabled ? 1 : 0
  tags                            = merge(var.tags, { "Name" = "${var.name}" })
  encrypted                       = var.encrypted
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
}

resource "aws_efs_mount_target" "main" {
  count           = local.enabled && length(var.azones) > 0 ? length(var.azones) : 0
  file_system_id  = join("", aws_efs_file_system.main.*.id)
  ip_address      = var.mount_target_ip_address
  subnet_id       = element(var.subnets, count.index)
  security_groups = [join("", aws_security_group.main.*.id)]
}

resource "aws_security_group" "main" {
  count       = local.enabled ? 1 : 0
  name        = "${var.name}-efs-sg"
  description = "EFS"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  # ingress {
  #   from_port       = "2049"
  #   to_port         = "2049"
  #   protocol        = "tcp"
  #   security_groups = var.security_groups
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

