output "vpc_id" {
    value = aws_vpc.roboshop_vpc.id
  
}

output "public_subnets" {
    value = aws_subnet.public_subnets[*].id
  
}