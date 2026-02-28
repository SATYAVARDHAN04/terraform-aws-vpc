# fecthing vailability zones

data "aws_availability_zones" "availableaz" {
  state = "available"
}

# output "az-testing" {
#     value = data.aws_availability_zones.available
# }

#geting default vpc id
data "aws_vpc" "default" {
  default = true
}

#geting default vpc route table id
data "aws_route_table" "default" {
  vpc_id = data.aws_vpc.default.id # Reference the ID of your specific VPC
}
