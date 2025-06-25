locals {
  comon_tag = {
    Poject = var.project
    Environment = var.env
    Terraform = "true"
  }

  az_name = slice(data.aws_availability_zones.ava_zone.names,0,2)
}