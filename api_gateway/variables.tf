########################### API REST ###############################

##### aws_api_gateway_api_key

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_api_gateway_rest_api

variable "apigw_name" {
  default     = ""
  description = "Name of the API key"
}

variable "binary_media_types" {}

##### api_gateway_authorizer

variable "aws_region" {
  default     = ""
  description = "The VPC's region. Defaults to the region of the AWS provider."
}

variable "rest_api_id" {}
variable "authorizer_name" {}
variable "authorizer_uri" {}
variable "authorizer_credentials" {}
variable "type" {
  default = "TOKEN"
}
variable "identity_validation_expression" {}
variable "ttl_seconds" {
  default = "60"
}

##### aws_api_gateway_deployment

variable "stage_name" {
  type    = string
  default = ""
}

##### custom_domain_name

variable "domain_name" {
  description = "Name of the API key"
}

variable "certificate_arn" {
  description = "Name of the API key"
}

variable "domain_name" {
  description = "Name of the API key"
}

##### aws_api_gateway_integration

variable "rest_api_id" {}
variable "root_resource_id" {}
variable "http_method" {}
variable "type" {}
variable "connection_type" {
  default = null
}
variable "connection_id" {
  default = null
}
variable "uri" {
  default = null
}
variable "integration_http_method" {
  default = null
}
variable "request_parameters" {
  default = null
}
variable "cache_key_parameters" {
  default = null
}

variable "request_templates" {
  default = null
}

##### aws_api_gateway_integration_response

variable "root_resource_id" {}
variable "http_method" {}
variable "status_code" {}
variable "response_parameters" {
  default = null
}
variable "response_templates" {
  default = null
}

##### aws_api_gateway_method

variable "root_resource_id" {}
variable "http_method" {}
variable "authorizer_type" {
  default = "NONE"
}
variable "authorizer_id" {
  default = ""
}
variable "request_parameters" {
  default = null
}

##### aws_api_gateway_method_response

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id         = var.rest_api_id
  resource_id         = var.root_resource_id
  http_method         = var.http_method
  status_code         = var.status_code
  response_models     = var.response_models
  response_parameters = var.response_parameters
}

##### aws_api_gateway_base_path_mapping

variable "base_path" {}


##### aws_api_gateway_resource

variable "path_part" {
  default = "{proxy+}"
}

##### aws_api_gateway_vpc_link

variable "lb_name" {
  default = ""
}

########################### WEBSOCKET ###############################

##### aws_apigatewayv2_api

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_domain_name

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_stage

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_api_mapping

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_authorizer

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_deployment

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_integration

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_integration_response

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_route

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_route_response

variable "api_key_name" {
  description = "Name of the API key"
}

##### aws_apigatewayv2_vpc_link

variable "api_key_name" {
  description = "Name of the API key"
}