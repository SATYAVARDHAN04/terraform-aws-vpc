resource "aws_vpc_peering_connection" "foo" {
  count = var.is_peering_required ? 1 : 0
  # peer_owner_id = var.peer_owner_id --> since same account default is taken
  peer_vpc_id = data.aws_vpc.default.id
  vpc_id      = aws_vpc.roboshop.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  auto_accept = true
  tags = merge(local.common_tags, var.vpc_peering_tags, {
    Name = "${var.project}-${var.environment}-peering"
  })
}

resource "aws_route" "public_peering" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public_route.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id #note
}

resource "aws_route" "private_peering" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private_route.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id #note
}

resource "aws_route" "database_peering" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database_route.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id #note
}

# we should it in default vpc main route table
resource "aws_route" "default_peering" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id #note
}