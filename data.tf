data "aws_availability_zones" "ava_zone" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}

# output "new" {
#   value = data.aws_availability_zones.ava_zone
# }