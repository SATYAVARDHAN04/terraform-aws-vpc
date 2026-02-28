variable "cidr" {
    type = string
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
    type = map()
    default = {}
}