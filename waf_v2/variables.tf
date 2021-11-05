variable "name" {}

variable "scope" {
  default = "REGIONAL"
}

variable "description" {
  default = null
}

variable "default_allow" {
  default = true
}

variable "visibility_config" {
  default = {}
}

variable "rules" {}

variable "attached_resources" {
  default = []
}

variable "tags" {
  default = {}
}