# roboshop-dev-vpc

resource "aws_vpc" "roboshop" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = local.common_tags
}