vpc_config = {
  name                   = "WL-cross-VPC"
  cidr_block             = "172.22.96.0/19"
  additional_cidr_blocks = []
  public_subnets = [
    {
      name        = "WL-cross-PUB-1"
      az          = "us-east-1a"
      cidr_block  = "172.22.96.0/22"
      nat_gw_name = "WL-cross-NAT-01"
    },
    {
      name        = "WL-cross-PUB-2"
      az          = "us-east-1d"
      cidr_block  = "172.22.100.0/22"
      nat_gw_name = "WL-cross-NAT-02"
    }

  ]
  public_route_table_name = "WL-cross-PUB-RT"
  private_subnets = [
    {
      name       = "WL-cross-PRI-1"
      az         = "us-east-1a"
      cidr_block = "172.22.104.0/21"
    },
    {
      name       = "WL-cross-PRI-2"
      az         = "us-east-1d"
      cidr_block = "172.22.112.0/21"
    },
    {
      name       = "WL-cross-PRI-3"
      az         = "us-east-1a"
      cidr_block = "172.22.120.0/22"
    },
    {
      name       = "WL-cross-PRI-4"
      az         = "us-east-1a"
      cidr_block = "172.22.124.0/23"
    },
    {
      name       = "WL-cross-PRI-5"
      az         = "us-east-1c"
      cidr_block = "172.22.126.0/23"
    }

  ]
  private_route_table_names = ["WL-cross-PRI-RT1", "WL-cross-PRI-RT2"]
  #private_route_table_names = ["WL-cross-PRI-RT1"]
  nacl_name = "WL-cross-NACL"
  igw_name  = "WL-cross-IGW"
}