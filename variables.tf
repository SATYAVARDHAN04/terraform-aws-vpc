variable "cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "project" {
    type = string
    default = "roboshop"
}

variable "environment" {
    type = string
    default = "dev"
}