vpc_config = {
  name                   = "ST-Operations-VPC"
  cidr_block             = "172.22.128.0/19"
  additional_cidr_blocks = []
  public_subnets = [
    {
      name        = "ST-OPR-PUB-1"
      az          = "us-east-1a"
      cidr_block  = "172.22.128.0/22"
      nat_gw_name = "ST-OPR-NAT-01"
    },
    {
      name        = "ST-OPR-PUB-2"
      az          = "us-east-1d"
      cidr_block  = "172.22.132.0/22"
      nat_gw_name = "ST-OPR-NAT-02"
    }
  ]
  public_route_table_name = "ST-OPR-PUB-RT"
  private_subnets = [
    {
      name       = "ST-OPR-PRI-1"
      az         = "us-east-1a"
      cidr_block = "172.22.136.0/21"
    },
    {
      name       = "ST-OPR-PRI-2"
      az         = "us-east-1d"
      cidr_block = "172.22.144.0/21"
    },
    {
      name       = "ST-OPR-PRI-3"
      az         = "us-east-1a"
      cidr_block = "172.22.152.0/22"
    },
    {
      name       = "ST-OPR-PRI-4"
      az         = "us-east-1d"
      cidr_block = "172.22.156.0/22"
    }

  ]
  private_route_table_names = ["ST-OPR-PRI-RT1", "ST-OPR-PRI-RT2"]
  nacl_name                 = "ST-OPR-NACL"
  igw_name                  = "ST-OPR-IGW"
}