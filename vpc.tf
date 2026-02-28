#VPC CREATION
# roboshop-dev-vpc
# roboshop-dev-igw
resource "aws_vpc" "roboshop" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = merge(var.vpc_tags, local.common_tags, {
    Name = "${var.project}-${var.environment}-vpc"
  })
}

# internet gateway
resource "aws_internet_gateway" "roboshop-igw" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-igw"
  })
}

# Subnets
#roboshop-dev-public-us-east-1a
resource "aws_subnet" "roboshop-public" {
  vpc_id                  = aws_vpc.roboshop.id
  count                   = length(var.public_subnet_cidr)
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.availableaz.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-public-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}

#roboshop-dev-private-us-east-1a
resource "aws_subnet" "roboshop-private" {
  vpc_id                  = aws_vpc.roboshop.id
  count                   = length(var.private_subnet_cidr)
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.availableaz.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-private-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}

#roboshop-dev-database-us-east-1a
resource "aws_subnet" "roboshop-database" {
  vpc_id                  = aws_vpc.roboshop.id
  count                   = length(var.database_subnet_cidr)
  cidr_block              = var.database_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.availableaz.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-databse-${data.aws_availability_zones.availableaz.names[count.index]}"
  })
}

#Elastic IP
resource "aws_eip" "elasticip" {
  domain = "vpc"
  tags = merge(local.common_tags, var.eip_tags, {
    Name = "${var.project}-${var.environment}-EIP"
  })
}

resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.roboshop-public[0].id

  tags = merge(local.common_tags, var.nat_tags, {
    Name = "${var.project}-${var.environment}-natgateway"
  })
  depends_on = [aws_internet_gateway.roboshop-igw]
}

# route tables
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(local.common_tags, var.public_rt_tags, {
    Name = "${var.project}-${var.environment}-publicrt"
  })
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(local.common_tags, var.private_rt_tags, {
    Name = "${var.project}-${var.environment}-publicrt"
  })
}

resource "aws_route_table" "database_route" {
  vpc_id = aws_vpc.roboshop.id
  tags = merge(local.common_tags, var.database_rt_tags, {
    Name = "${var.project}-${var.environment}-publicrt"
  })
}

# routes
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.roboshop-igw.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgateway.id
}

resource "aws_route" "databse" {
  route_table_id         = aws_route_table.database_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgateway.id
}

#subnet route table assosiations
resource "aws_route_table_association" "public-subnet-association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.roboshop-public[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private-subnet-association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.roboshop-private[count.index].id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "databse-subnet-association" {
  count          = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.roboshop-database[count.index].id
  route_table_id = aws_route_table.database_route.id
}