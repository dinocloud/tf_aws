locals {
  igw_name = "${var.name}-${var.environment}-igw"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = merge(map("Name", format("%s", local.igw_name)), var.identifier_tags)
}