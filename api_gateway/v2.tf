########################### WEBSOCKET ###############################

####### aws_apigatewayv2_api #######

resource "aws_apigatewayv2_api" "this" {
  count = var.create && var.create_api_gateway ? 1 : 0

  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type #WEBSOCKET o HTTP
  version       = var.api_version
  tags          = var.tags

  route_selection_expression   = var.route_selection_expression  # "$request.body.action"
  api_key_selection_expression = var.api_key_selection_expression
  disable_execute_api_endpoint = var.disable_execute_api_endpoint

####### aws_apigatewayv2_domain_name #######

resource "aws_apigatewayv2_domain_name" "this" {
  domain_name = "ws-api.this.com"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.this.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

####### aws_apigatewayv2_stage #######

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "this-stage"
}

####### aws_apigatewayv2_api_mapping #######

resource "aws_apigatewayv2_api_mapping" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this.id
  stage       = aws_apigatewayv2_stage.this.id
}


####### aws_apigatewayv2_authorizer #######

resource "aws_apigatewayv2_authorizer" "this" {
  name             = "this-authorizer"
  api_id           = aws_apigatewayv2_api.this.id
  authorizer_type  = "REQUEST"
  authorizer_uri   = aws_lambda_function.this.invoke_arn
  identity_sources = ["route.request.header.Auth"]
  
}

####### aws_apigatewayv2_deployment #######

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_route.this.api_id
  description = "this deployment"

  lifecycle {
    create_before_destroy = true
  }
}

####### aws_apigatewayv2_integration #######

### Private Integration ####

resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  credentials_arn  = aws_iam_role.this.arn
  description      = "this with a load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.this.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"

  tls_config {
    server_name_to_verify = "this.com"
  }

  request_parameters = {
    "append:header.authforintegration" = "$context.authorizer.authorizerResponse"
    "overwrite:path"                   = "staticValueForIntegration"
  }

  response_parameters {
    status_code = 403
    mappings = {
      "append:header.auth" = "$context.authorizer.authorizerResponse"
    }
  }

  response_parameters {
    status_code = 200
    mappings = {
      "overwrite:statuscode" = "204"
    }
  }
}

####### aws_apigatewayv2_integration_response #######

resource "aws_apigatewayv2_integration_response" "this" {
  api_id                   = aws_apigatewayv2_api.this.id
  integration_id           = aws_apigatewayv2_integration.this.id
  integration_response_key = "/200/"
}

####### aws_apigatewayv2_route #######

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$default"
}

####### aws_apigatewayv2_route_response #######

resource "aws_apigatewayv2_route_response" "this" {
  api_id             = aws_apigatewayv2_api.this.id
  route_id           = aws_apigatewayv2_route.this.id
  route_response_key = "$default"
}


####### aws_apigatewayv2_vpc_link #######

resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "this"
  security_group_ids = [data.aws_security_group.this.id]
  subnet_ids         = data.aws_subnet_ids.this.ids

  tags = {
    Usage = "this"
  }
}

####### aws_apigatewayv2_api #######

  # Access logs
  default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "POST /" = {
      lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
    }
  }

  tags = {
    Name = "http-apigateway"
  }
}