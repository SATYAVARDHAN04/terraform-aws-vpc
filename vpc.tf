# roboshop-dev-vpc
# roboshop-dev-igw
resource "aws_vpc" "roboshop" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-igw"
  })
}