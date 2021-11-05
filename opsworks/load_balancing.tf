locals {
  priv_hostnames = concat(
    [for i in var.hostnames.private.aivoco : "${i}.aivo.co"],
    [for i in var.hostnames.private.agentbot : "${i}.agentbot.net"]
  )

  pub_hostnames = concat(
    [for i in var.hostnames.public.aivoco : "${i}.aivo.co"],
    [for i in var.hostnames.public.agentbot : "${i}.agentbot.net"]
  )

  healthcheck = merge({
    path                = "/"
    interval            = 10
    unhealthy_threshold = 3
    healthy_threshold   = 3
    healthy_timeout     = 5
  }, var.healthcheck_config)
}

##ALB Sg
resource "aws_security_group" "alb_sg" {
  name        = "OpsWorks ALBs sg"
  vpc_id      = var.vpc_id
  description = "OpsWorks ALBs sg"
  tags        = var.tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpc_cidr
  }
}

## Load Balancers
resource "aws_lb" "public" {
  name               = "opsworks-pub-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
  tags               = var.tags
}

resource "aws_lb" "internal" {
  name               = "opsworks-int-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.private_subnets
  tags               = var.tags
}

## Public Listeners
resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "public_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.https_certs[0]

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_certificate" "extra_certs" {
  count           = length(var.https_certs) - 1
  listener_arn    = aws_lb_listener.public_https.arn
  certificate_arn = var.https_certs[count.index + 1]
}

## Internal Listeners
resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener" "internal_https" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.https_certs[0]

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
  }
}

resource "aws_lb_listener_certificate" "extra_certs_int" {
  count           = length(var.https_certs) - 1
  listener_arn    = aws_lb_listener.internal_https.arn
  certificate_arn = var.https_certs[count.index + 1]
}

## Target Groups
resource "aws_alb_target_group" "tg" {
  name        = var.environment == "PROD" ? "opsworks-pub-tg" : "opsworks-pub-${lower(var.environment)}-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  tags        = var.tags

  dynamic "health_check" {
    for_each = var.healthcheck_config != {} ? local.healthcheck : {}
    content {
      path                = health_check.path
      interval            = health_check.interval
      timeout             = health_check.healthy_timeout
      healthy_threshold   = health_check.healthy_threshold
      unhealthy_threshold = health_check.unhealthy_threshold
    }
  }
}

resource "aws_alb_target_group" "public_tg" {
  count       = var.public ? 1 : 0
  name        = var.environment == "PROD" ? "opsworks-int-tg" : "opsworks-int-${lower(var.environment)}-tg"
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  tags        = var.tags

  dynamic "health_check" {
    for_each = var.healthcheck_config != {} ? local.healthcheck : {}
    content {
      path                = health_check.path
      interval            = health_check.interval
      timeout             = health_check.healthy_timeout
      healthy_threshold   = health_check.healthy_threshold
      unhealthy_threshold = health_check.unhealthy_threshold
    }
  }
}

## Internal LBs Listeners Rule ##############
resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.internal_http.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }
  condition {
    host_header {
      values = local.priv_hostnames
    }
  }
}

resource "aws_lb_listener_rule" "https_rule" {
  listener_arn = aws_lb_listener.internal_https.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }
  condition {
    host_header {
      values = local.priv_hostnames
    }
  }
}

## Public LBs Listeners Rule ##############
resource "aws_lb_listener_rule" "public_https_rule" {
  count        = length(local.pub_hostnames) > 0 ? 1 : 0
  listener_arn = aws_lb_listener.public_https.arn
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.public_tg[0].arn
  }
  condition {
    host_header {
      values = local.pub_hostnames
    }
  }
}

## TG attachements
resource "aws_lb_target_group_attachment" "internal" {
  for_each         = var.instances
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_opsworks_instance.instances[each.key].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "public" {
  for_each         = var.instances
  target_group_arn = aws_alb_target_group.public_tg[0].arn
  target_id        = aws_opsworks_instance.instances[each.key].id
  port             = 80
}