# fecthing vailability zones

data "aws_availability_zones" "availableaz" {
  state = "available"
}

# output "az-testing" {
#     value = data.aws_availability_zones.available
# }