# AWS VPC MODULE

You can create VPC in your AWS using this module

## INPUT

- project(required) - It is the name that you give your VPC
- env(required) - It tells which environment you are choosing like (dev/prod/stage)
- cidr_block(optional) - It give the range of IP address allowed within the VPC (default 10.0.0.0/16)
- pub_subnet(optional) - It indiates the range of the IP address that are allowed in the subnet\

## OUTPUT

- vpc_id - It is the VPC ID of the created vpc using this module