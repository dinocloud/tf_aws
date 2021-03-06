# module: aws_vpc_endpoint

variable "vpc_id" {}

variable "service" {}

variable "enable_vpc_endpoint" {
  default = "1"
}

variable "private_dns_enabled" {
  default = false
}
