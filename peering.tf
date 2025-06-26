resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id #accecptor
  vpc_id        = aws_vpc.roboshop_vpc.id #requester

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  auto_accept = true

  tags = merge(
    var.peering_tags,
    local.common_tag, {
      Name = "${var.project}-${var.env}-default"
    }
  )
}

#VPC PEERING ROUTE
resource "aws_route" "public_peering_route" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "private_peering_route" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

resource "aws_route" "db_peering_route" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.db_rt.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

#Adding peering connection in default subnet 
resource "aws_route" "default_peering_route" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}