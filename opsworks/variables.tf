variable "public_subnets" {
  default = []
}

variable "private_subnets" {
  default = []
}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "region" {}

variable "environment" {}

variable "tags" {}

variable "stack" {}

variable "https_certs" {}

variable "layers" {
  default = []
}

variable "instances" {
  default = {}
}

variable "applications" {
  default = {}
}

variable "healthcheck_config" {
  default = {}
}

variable "port" {
  default = 80
}

variable "aivoco_hostnames" {}

variable "agentbot_hostnames" {}

variable "public" {
  default = false
}

variable "hosted_zones" {}

variable "hostnames" {}