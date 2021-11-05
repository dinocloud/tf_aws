variable "domain" {}

variable "validation_method" {
  default = "DNS"
}

variable "alt_names" {
  default = []
}

variable "validation_hz_id" {
  default = ""
}

variable "tags" {
  default = {}
}