
variable "vpc_config" {
  description = "an object containing config parameters for the vpc"
  type = object({
    name                      = string,
    cidr_block                = string,
    additional_cidr_blocks    = list(string),
    public_subnets            = list(map(string)),
    public_route_table_name   = string,
    private_subnets           = list(map(string)),
    private_route_table_names = list(string),
    nacl_name                 = string,
    igw_name                  = string
  })
}

module "vpc" {
  source     = "../modules/vpc"
  vpc_config = var.vpc_config
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_route_table_association" "private_rt1" {
  for_each       = toset(["0", "2"])
  route_table_id = module.vpc.private_route_tables[0].id
  subnet_id      = module.vpc.private_subnets[tonumber(each.value)].id
}

resource "aws_route_table_association" "private_rt2" {
  for_each       = toset(["1", "3"])
  route_table_id = module.vpc.private_route_tables[1].id
  subnet_id      = module.vpc.private_subnets[tonumber(each.value)].id
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = module.vpc.vpc
  dhcp_options_id = aws_vpc_dhcp_options.wel.id
}

resource "aws_vpc_dhcp_options" "wel" {
  domain_name         = "wellops.local"
  domain_name_servers = ["AmazonProvidedDNS"]

}