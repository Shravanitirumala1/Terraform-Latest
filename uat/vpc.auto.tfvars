vpc_config = {
  name                   = "ST-UAT-VPC"
  cidr_block             = "172.22.32.0/19"
  additional_cidr_blocks = []
  public_subnets = [
    {
      name        = "ST-UAT-PUB-1"
      az          = "us-east-1a"
      cidr_block  = "172.22.32.0/22"
      nat_gw_name = "ST-UAT-NAT-01"
    },
    {
      name        = "ST-UAT-PUB-2"
      az          = "us-east-1d"
      cidr_block  = "172.22.36.0/22"
      nat_gw_name = "ST-UAT-NAT-02"
    }

  ]
  public_route_table_name = "ST-UAT-PUB-RT"
  private_subnets = [
    {
      name       = "ST-UAT-PRI-1"
      az         = "us-east-1a"
      cidr_block = "172.22.40.0/21"
    },
    {
      name       = "ST-UAT-PRI-2"
      az         = "us-east-1d"
      cidr_block = "172.22.48.0/21"
    },
    {
      name       = "ST-UAT-PRI-3"
      az         = "us-east-1a"
      cidr_block = "172.22.56.0/22"
    },
    {
      name       = "ST-UAT-PRI-4"
      az         = "us-east-1a"
      cidr_block = "172.22.60.0/23"
    },
    {
      name       = "ST-UAT-PRI-5"
      az         = "us-east-1c"
      cidr_block = "172.22.62.0/23"
    }

  ]
  private_route_table_names = ["ST-UAT-PRI-RT1", "ST-UAT-PRI-RT2"]
  #private_route_table_names = ["ST-UAT-PRI-RT1"]
  nacl_name = "ST-UAT-NACL"
  igw_name  = "ST-UAT-IGW"
}