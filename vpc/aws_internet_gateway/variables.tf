variable "vpc_id" {
  type = string
}

variable "environment" {}

variable "name" {}

variable "identifier_tags" {
  type    = map(any)
  default = {}
}

