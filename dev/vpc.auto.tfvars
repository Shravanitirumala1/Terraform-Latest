vpc_config = {
  name                   = "ST-Development-VPC"
  cidr_block             = "172.22.64.0/19"
  additional_cidr_blocks = []
  public_subnets = [
    {
      name        = "ST-DEV-PUB-1"
      az          = "us-eaST-1a"
      cidr_block  = "172.22.64.0/22"
      nat_gw_name = "ST-DEV-NAT-01"
    }
  ]
  public_route_table_name = "ST-DEV-PUB-RT"
  private_subnets = [
    {
      name       = "ST-DEV-PRI-1"
      az         = "us-eaST-1a"
      cidr_block = "172.22.80.0/20"
    },
    {
      name       = "ST-DEV-PRI-2"
      az         = "us-eaST-1d"
      cidr_block = "172.22.72.0/21"
    },
    {
      name       = "ST-DEV-PRI-3"
      az         = "us-eaST-1a"
      cidr_block = "172.22.68.0/22"
    }

  ]
  #private_route_table_names = ["ST-DEV-PRI-RT1", "ST-DEV-PRI-RT2"]
  private_route_table_names = ["ST-DEV-PRI-RT1"]
  nacl_name                 = "ST-DEV-NACL"
  igw_name                  = "ST-DEV-IGW"
}