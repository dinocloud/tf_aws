
########################### API REST ###############################

####### aws_api_gateway_rest_api #######

output "apigw_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.this.root_resource_id
}

####### aws_api_gateway_api_key #######



####### api_gateway_authorizer #######

output "authorizer_id" {
  value = aws_api_gateway_authorizer.authorizer.id
}

####### custom_domain_name #######



####### aws_api_gateway_integration #######



####### aws_api_gateway_integration_response #######



#######  aws_api_gateway_method #######

output "http_method" {
  value = aws_api_gateway_method.method.http_method
}

####### aws_api_gateway_method_response #######

output "status_code" {
  value = aws_api_gateway_method_response.method_response.status_code
}

####### aws_api_gateway_resource #######

output "resource_id" {
  value = aws_api_gateway_resource.resource.id
}

####### aws_api_gateway_vpc_link #######



########################### WEBSOCKET ###############################

####### aws_apigatewayv2_api #######



####### aws_apigatewayv2_domain_name #######



####### aws_apigatewayv2_stage #######



#######  aws_apigatewayv2_api_mapping #######



####### aws_apigatewayv2_authorizer #######



####### aws_apigatewayv2_deployment #######



#######  aws_apigatewayv2_integration #######



####### aws_apigatewayv2_integration_response #######



####### aws_apigatewayv2_route #######



#######  aws_apigatewayv2_route_response #######



####### aws_apigatewayv2_vpc_link #######




