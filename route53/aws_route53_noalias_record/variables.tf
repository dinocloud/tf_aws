variable "aliases" {
  type        = list(any)
  description = "List of aliases"
}

variable "parent_zone_id" {
  default     = ""
  description = "ID of the hosted zone to contain this record  (or specify `parent_zone_name`)"
}

variable "parent_zone_name" {
  default     = ""
  description = "Name of the hosted zone to contain this record (or specify `parent_zone_id`)"
}

variable "enabled" {
  default = "true"
}

variable "cname_value" {
}

variable "set_identifier" {
  default = ""
}

variable "weight" {
  default = 1
}