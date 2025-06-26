# VPC creation - roboshop-dev
resource "aws_vpc" "roboshop_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    var.vpc_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "roboshop_igw" {
  vpc_id = aws_vpc.roboshop_vpc.id

  tags = merge(
    var.igw_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.pub_subnet)
  vpc_id                  = aws_vpc.roboshop_vpc.id
  cidr_block              = var.pub_subnet[count.index]
  availability_zone       = local.az_name[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.pub_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-public-${local.az_name[count.index]}"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.pri_subnet)
  vpc_id            = aws_vpc.roboshop_vpc.id
  cidr_block        = var.pri_subnet[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(
    var.pri_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-private-${local.az_name[count.index]}"
    }
  )
}

# Database Subnets
resource "aws_subnet" "db_subnets" {
  count             = length(var.db_subnet)
  vpc_id            = aws_vpc.roboshop_vpc.id
  cidr_block        = var.db_subnet[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(
    var.data_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-database-${local.az_name[count.index]}"
    }
  )
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    var.eip_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}"
    }
  )
}

# NAT Gateway
resource "aws_nat_gateway" "roboshop_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(
    var.nat_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}"
    }
  )

  depends_on = [aws_internet_gateway.roboshop_igw]
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.roboshop_vpc.id

  tags = merge(
    var.publicroute_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-public"
    }
  )
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.roboshop_vpc.id

  tags = merge(
    var.privateroute_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-private"
    }
  )
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.roboshop_vpc.id

  tags = merge(
    var.databaseroute_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-database"
    }
  )
}

# Route Definitions
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.roboshop_igw.id
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.roboshop_nat.id
}

resource "aws_route" "db_nat_route" {
  route_table_id         = aws_route_table.db_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.roboshop_nat.id
}

# Route Table Associations
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.pub_subnet)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.pri_subnet)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_assoc" {
  count          = length(var.db_subnet)
  subnet_id      = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.db_rt.id
}
