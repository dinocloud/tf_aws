api_gw {
  type = "WEBSOCKET"
  cors_enabled =

  resources = {
    methods = {

    }
  }
  stages = 
  authorizers = 
}

# module core_api {
#   name = "core"
#   type = "rest"
#   filename =
#   custom_domain_name = {
#     "api"
#     base_domain = ""
#     acm_cert_arn = ""
#     hosted_zone_id = ""
#   }
#   variables = {
#     #host = "api.${var.environment}.sistemasurbano.com"
#     vpc_link_id = module.ecs_infra.vpc_link_id
#     endpoint = "http://${module.ecs_infra.internal_lb_dns}:7000"
#   }
# }



########################### API REST ###############################

data "aws_iam_role" "cloudwatch" {
  name = "apigw-cloudwatch-role"
}


