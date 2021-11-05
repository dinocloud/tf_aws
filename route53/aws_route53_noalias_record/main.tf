data "aws_route53_zone" "default" {
  count   = signum(length(compact(var.aliases)))
  zone_id = var.parent_zone_id
  name    = var.parent_zone_name
}

resource "aws_route53_record" "default" {
  count   = var.enabled == "true" ? length(compact(var.aliases)) : 0
  zone_id = data.aws_route53_zone.default[0].zone_id
  name    = element(compact(var.aliases), count.index)
  type    = "CNAME"
  ttl     = "300"
  records = [var.cname_value]

  weighted_routing_policy {
    weight = var.weight
  }

  set_identifier = var.set_identifier
}

