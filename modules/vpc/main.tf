
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_config["cidr_block"]
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_config["name"]
  }
}


resource "aws_subnet" "public_subnets" {
  count                   = length(var.vpc_config["public_subnets"])
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.vpc_config["public_subnets"][count.index]["az"]
  cidr_block              = var.vpc_config["public_subnets"][count.index]["cidr_block"]
  map_public_ip_on_launch = true
  # tags = {
  #   Name = var.vpc_config["public_subnets"][count.index]["name"]
  # }
  tags = merge(
    { "Name" = var.vpc_config["public_subnets"][count.index]["name"] },
    var.tags,
    var.public_subnet_tags
  )
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.vpc_config["private_subnets"])
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.vpc_config["private_subnets"][count.index]["az"]
  cidr_block        = var.vpc_config["private_subnets"][count.index]["cidr_block"]

  # tags = {
  #   Name = var.vpc_config["private_subnets"][count.index]["name"]
  # }
  tags = merge(
    { "Name" = var.vpc_config["private_subnets"][count.index]["name"] },
    var.tags,
    var.private_subnet_tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.vpc_config["igw_name"]
  }
}

resource "aws_eip" "nat_public_ip" {
  count = length(var.vpc_config["public_subnets"])
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.vpc_config["public_subnets"])
  allocation_id = aws_eip.nat_public_ip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = var.vpc_config["public_subnets"][count.index]["nat_gw_name"]
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_config["public_route_table_name"]
  }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.vpc_config["public_subnets"])
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table" "private" {
  count  = length(var.vpc_config["private_route_table_names"])
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.vpc_config["private_route_table_names"][count.index]
  }
}

#resource "aws_route" "private_default" {
#  count                  = length(var.vpc_config["private_route_table_names"])
#  route_table_id         = aws_route_table.private[count.index].id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = aws_nat_gateway.nat_gw[count.index].id
#}

resource "aws_route" "transit_default" {
  count                  = length(var.vpc_config["private_route_table_names"])
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = "tgw-045e7f8fb37a340d6" #aws_nat_gateway.nat_gw[count.index].id
}


resource "aws_default_network_acl" "allow_all" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  subnet_ids             = concat([for a in aws_subnet.public_subnets : a.id], [for b in aws_subnet.private_subnets : b.id])

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = var.vpc_config["nacl_name"]
  }
}
