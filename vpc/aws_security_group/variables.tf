variable "name" {}

variable "description" {
  default = ""
}

variable "vpc_id" {}

variable "tags" {}

variable "sg_ingress_rules" {
  type    = list(any)
  default = []
}

variable "cidr_ingress_rules" {
  type    = list(any)
  default = []
}

variable "create_sg" {
  default = true
}

variable "public_ingress" {
  default = false
}

variable "port" {
  default = ""
}

variable "protocol" {
  default = ""
}