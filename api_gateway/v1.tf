####### aws_api_gateway_rest_api #######

resource "aws_api_gateway_rest_api" "apigw" {
  name               = var.apigw_name
  binary_media_types = var.binary_media_types
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

####### aws_api_gateway_deployment #######

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  stage_name  = var.stage_name
}

####### custom_domain_name #######

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.deploy.id
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  stage_name    = var.stage_name
}