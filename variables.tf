variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "database_subnet_cidr" {
  type = list(string)
}

variable "vpc_tags" {
  type    = map(string)
  default = {}
}

variable "nat_tags" {
  type    = map(string)
  default = {}
}

variable "eip_tags" {
  type    = map(string)
  default = {}
}

variable "public_rt_tags" {
  type    = map(string)
  default = {}
}

variable "private_rt_tags" {
  type    = map(string)
  default = {}
}

variable "database_rt_tags" {
  type    = map(string)
  default = {}
} 