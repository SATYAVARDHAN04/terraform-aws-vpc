locals {
  common_tags={
    project=var.project
    environment=var.environment
    Name="${var.project}-${var.environment}-vpc"
  }
}