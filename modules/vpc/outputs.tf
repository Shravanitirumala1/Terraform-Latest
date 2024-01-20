output "vpc" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnets
}

output "private_subnets" {
  value = aws_subnet.private_subnets
}

output "igw" {
  value = aws_internet_gateway.igw
}

output "nat_gws" {
  value = aws_nat_gateway.nat_gw
}

output "nat_public_ips" {
  value = aws_eip.nat_public_ip
}

output "public_route_table" {
  value = aws_route_table.public
}

output "private_route_tables" {
  value = aws_route_table.private
}

