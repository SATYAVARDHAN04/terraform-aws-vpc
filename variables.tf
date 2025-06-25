variable "cidr_block" {
    default = "10.0.0.0/16"  
}

variable "project" {
    type = string
}

variable "env" {
    type = string
}

variable "pub_subnet" {
    type = list(string)
}

variable "pri_subnet" {
    type = list(string)
}

variable "db_subnet" {
    type = list(string)
}

variable "vpc_tags" {
    type = map(string)
    default = {}
  
}

variable "pub_tags" {
    type = map(string)
    default = {}  
}

variable "igw_tags" {
    type = map(string)
    default = {}
}

variable "pri_tags" {
    type = map(string)
    default = {}  
}

variable "data_tags" {
    type = map(string)
    default = {}  
}

variable "nat_tags" {
    type = map(string)
    default = {}
}

variable "eip_tags" {
    type = map(string)
    default = {}
}

variable "publicroute_tags" {
    type = map(string)
    default = {}
  
}

variable "privateroute_tags" {
    type = map(string)
    default = {}
  
}

variable "databaseroute_tags" {
    type = map(string)
    default = {}
  
}

variable "is_peering_required" {
    default = false
}

variable "peering_tags" {
    type = map(string)
    default = {}
  
}