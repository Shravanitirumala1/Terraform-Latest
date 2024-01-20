locals {
  dev_vpc_cidr_block = "172.22.64.0/19"
  ops_vpc_cidr_block = "172.22.128.0/19"
}


module "es-sg" {
  source      = "../modules/security-group"
  name        = "ST-SEARCH-SG"
  vpc_id      = module.vpc.vpc
  description = "SEARCH SG"
  cidr_rules = {
    "out"   = ["egress", "all", 0, 0, "0.0.0.0/0", ""]
    "in-01" = ["ingress", "tcp", 80, 80, local.dev_vpc_cidr_block, "[HTTP]_DEV-VPC"]
    "in-02" = ["ingress", "tcp", 9300, 9300, local.dev_vpc_cidr_block, "[ELASTICSEARCH-]_DEV-VPC"]
    "in-03" = ["ingress", "tcp", 443, 443, local.dev_vpc_cidr_block, "[HTTPS]_DEV-VPC"]
    "in-04" = ["ingress", "tcp", 80, 80, local.ops_vpc_cidr_block, "[HTTP]_OPS-VPC"]
    "in-05" = ["ingress", "tcp", 9300, 9300, local.ops_vpc_cidr_block, "[ELASTICSEARCH-]_OPS-VPC"]
    "in-06" = ["ingress", "tcp", 443, 443, local.ops_vpc_cidr_block, "[HTTPS]_OPS-VPC"]
  }
  sg_rules = {
    "in-01" = ["ingress", "tcp", 0, 0, module.es-sg.id, "[ALL_TRAFFIC]_SELF"]
  }
}

module "eks-sg" {
  source      = "../modules/security-group"
  name        = "ST-EKS-SG"
  vpc_id      = module.vpc.vpc
  description = "EKS SG"
  cidr_rules = {
    "out"   = ["egress", "all", 0, 0, "0.0.0.0/0", ""]
    "in-01" = ["ingress", "tcp", 22, 22, local.dev_vpc_cidr_block, "[HTTP]_DEV-VPC"]
  }
  sg_rules = {
    "in-01" = ["ingress", "tcp", 0, 0, module.eks-sg.id, "[ALL_TRAFFIC]_SELF"]
  }
}


