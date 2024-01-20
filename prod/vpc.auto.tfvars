vpc_config = {
  name                   = "ST-PROD-VPC"
  cidr_block             = "172.22.96.0/19"
  additional_cidr_blocks = []
  public_subnets = [
    {
      name        = "ST-PROD-PUB-1"
      az          = "us-east-1a"
      cidr_block  = "172.22.96.0/22"
      nat_gw_name = "ST-PROD-NAT-01"
    },
    {
      name        = "ST-PROD-PUB-2"
      az          = "us-east-1d"
      cidr_block  = "172.22.100.0/22"
      nat_gw_name = "ST-PROD-NAT-02"
    }

  ]
  public_route_table_name = "ST-PROD-PUB-RT"
  private_subnets = [
    {
      name       = "ST-PROD-PRI-1"
      az         = "us-east-1a"
      cidr_block = "172.22.104.0/21"
    },
    {
      name       = "ST-PROD-PRI-2"
      az         = "us-east-1d"
      cidr_block = "172.22.112.0/21"
    },
    {
      name       = "ST-PROD-PRI-3"
      az         = "us-east-1a"
      cidr_block = "172.22.120.0/22"
    },
    {
      name       = "ST-PROD-PRI-4"
      az         = "us-east-1a"
      cidr_block = "172.22.124.0/23"
    },
    {
      name       = "ST-PROD-PRI-5"
      az         = "us-east-1c"
      cidr_block = "172.22.126.0/23"
    }

  ]
  private_route_table_names = ["ST-PROD-PRI-RT1", "ST-PROD-PRI-RT2"]
  #private_route_table_names = ["ST-PROD-PRI-RT1"]
  nacl_name = "ST-PROD-NACL"
  igw_name  = "ST-PROD-IGW"
}