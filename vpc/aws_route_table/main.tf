// module: aws_route_table

resource "aws_route_table" "main" {
  count            = var.route_table_count
  vpc_id           = var.vpc_id
  propagating_vgws = var.propagating_vgws
  tags             = merge(tomap({ "Name" = "${var.cluster_name} - ${var.purpose} - ${element(var.available_az, count.index)}" }), var.identifier_tags)
}

# resource "aws_vpc_endpoint_route_table_association" "vpc_endpoint" {
#   for_each        = { for i in var.vpc_endpoint_ids : i => null}
#   # count           = var.enable_s3_vpc_endpoint * var.route_table_count
#   vpc_endpoint_id = each.key
#   route_table_id  = element(aws_route_table.main.*.id, count.index)
# }

# resource "aws_vpc_endpoint_route_table_association" "dynamodb_vpc_endpoint_association" {
#   count           = var.enable_dynamodb_vpc_endpoint * var.route_table_count
#   vpc_endpoint_id = var.dynamodb_vpc_endpoint_id
#   route_table_id  = element(aws_route_table.main.*.id, count.index)
# }