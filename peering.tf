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

