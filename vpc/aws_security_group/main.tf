resource "aws_security_group" "this" {
  count       = var.create_sg == true ? 1 : 0
  name        = var.name
  vpc_id      = var.vpc_id
  description = var.description == "" ? var.name : var.description

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(tomap({ "Name" = var.name }), var.tags)
}

resource "aws_security_group_rule" "cidr_rule" {
  count       = var.create_sg == false || length(var.cidr_ingress_rules) == 0 ? 0 : 1
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.cidr_ingress_rules

  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "sg_rule" {
  count                    = var.create_sg == false || length(var.sg_ingress_rules) == 0 ? 0 : length(var.sg_ingress_rules)
  type                     = "ingress"
  from_port                = var.port == "" ? 0 : var.port
  to_port                  = var.port == "" ? 0 : var.port
  protocol                 = var.protocol == "" ? var.port == "" ? "-1" : "HTTP" : var.protocol
  source_security_group_id = var.sg_ingress_rules[count.index]

  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "public_http" {
  count       = var.create_sg == false || var.public_ingress == false ? 0 : 1
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "public_https" {
  count       = var.create_sg == false || var.public_ingress == false ? 0 : 1
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.this[0].id
}