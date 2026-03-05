output "vpc_id" {
  value = aws_vpc.roboshop.id
}

output "public_subnet_id" {
  value = aws_subnet.roboshop-public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.roboshop-private[*].id
}

output "database_subnet_id" {
  value = aws_subnet.roboshop-database[*].id
} 