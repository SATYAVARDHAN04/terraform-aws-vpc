# roboshop-dev-vpc
# roboshop-dev-igw
resource "aws_vpc" "roboshop" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(var.vpc_tags,local.common_tags,{
    Name="${var.project}-${var.environment}-vpc"
  })
}

resource "aws_internet_gateway" "roboshop-igw" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-igw"
  })
}

#roboshop-dev-public-us-east-1a
resource "aws_subnet" "roboshop-public" {
  vpc_id     = aws_vpc.roboshop.id
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.availableaz.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-public-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}

#roboshop-dev-private-us-east-1a
resource "aws_subnet" "roboshop-private" {
  vpc_id     = aws_vpc.roboshop.id
  count = length(var.private_subnet_cidr)
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.availableaz.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-private-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}

#roboshop-dev-database-us-east-1a
resource "aws_subnet" "roboshop-databse" {
  vpc_id     = aws_vpc.roboshop.id
  count = length(var.database_subnet_cidr)
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.availableaz.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags,{
    Name="${var.project}-${var.environment}-databse-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}