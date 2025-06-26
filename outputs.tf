output "vpc_id" {
    value = aws_vpc.roboshop_vpc.id
  
}

output "public_subnets-id" {
    # value = aws_subnet.public_subnets[*].id
    value = aws_vpc.roboshop_vpc.public_subnets[*].id
  
}

output "private_subnets-id" {
    # value = aws_subnet.public_subnets[*].id
    value = aws_vpc.roboshop_vpc.private_subnets[*].id
  
}

output "database_subnets-id" {
    # value = aws_subnet.public_subnets[*].id
    value = aws_vpc.roboshop_vpc.db_subnets[*].id
  
}