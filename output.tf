output "vpc_id" {
  value = aws_vpc.roboshop.id
}

output "public_subnet_id" {
  value = aws_subnet.roboshop-public[*].id
}