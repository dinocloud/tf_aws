// module: aws_subnet_setup

variable "user" {}

variable "name" {}

variable "available_az" {
  type = list(any)
}

variable "vpc_id" {}

variable "is_public" {}

variable "subnet_count" {}

variable "subnet_size" {}

variable "subnet_type" {}

variable "ngw_count" {
  default = 0
}

variable "gw_count" {
  default = 0
}

variable "cidr_block" {}

variable "subnet_assignment_list" {
  type = list(any)
}

variable "ngw_id_list" {
  type    = list(any)
  default = []
}

variable "gw_id" {
  default = ""
}

variable "dst_cidr_block" {
  default = "0.0.0.0/0"
}

variable "subnet_tag_values" {
  type    = map(any)
  default = {}
}

variable "identifier_tags" {
  type    = map(any)
  default = {}
}

variable "propagating_vgws" {
  type    = list(any)
  default = []
}

variable "s3_vpc_endpoint_id" {
  default = ""
}

variable "dynamodb_vpc_endpoint_id" {
  default = ""
}

variable "enable_s3_vpc_endpoint" {
  default = 0
}

variable "enable_dynamodb_vpc_endpoint" {
  default = 0
}

variable "enable_ops_peering_routes" {
  default = 0
}

variable "environment" {}

variable "vpc_endpoint_ids" {
  default = []
}