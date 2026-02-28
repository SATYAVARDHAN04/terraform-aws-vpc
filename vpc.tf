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

resource "aws_internet_gateway" "roboshop-igw" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-igw"
  })
}

#roboshop-dev-subnet-us-east-1a
resource "aws_subnet" "roboshop-public" {
  vpc_id     = aws_vpc.roboshop.id
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.availableaz.names[count.index]

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-public-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}

# resource "aws_subnet" "main" {
#   vpc_id     = aws_vpc.roboshop.id
#   count = length(var.public_subnet_cidr)
#   cidr_block = var.public_subnet_cidr[count.index]

#   tags = {
#     Name = "Main"
#   }
# }

# resource "aws_subnet" "main" {
#   vpc_id     = aws_vpc.roboshop.id
#   count = length(var.public_subnet_cidr)
#   cidr_block = var.public_subnet_cidr[count.index]

#   tags = {
#     Name = "Main"
#   }
# }