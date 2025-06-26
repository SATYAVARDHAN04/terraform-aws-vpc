output "vpc_id" {
    value = aws_vpc.roboshop_vpc.id
  
}

output "public_subnets-id" {
    value = aws_subnet.public_subnets[*].id
  
}