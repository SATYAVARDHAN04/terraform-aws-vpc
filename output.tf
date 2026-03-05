output "vpc_id" {
  value = aws_vpc.roboshop.id
}

output "public_subnet_cidr" {
  value = aws_subnet.roboshop-public[*].id
}