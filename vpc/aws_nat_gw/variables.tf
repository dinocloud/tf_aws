variable "ngw_count" {}

variable "nat_subnet_ids" {
  type = list(any)
}

variable "vpc_id" {}

variable "name" {}

variable "identifier_tags" {
  type    = map(any)
  default = {}
}
