locals {
  operations_vpc_cidr_block = "172.22.128.0/19"

}


module "sq-sg" {
  source      = "../modules/security-group"
  name        = "ST-SONARQUBE-SG"
  vpc_id      = module.vpc.vpc
  description = "Sonarqube SG"
  cidr_rules = {
    "out"   = ["egress", "all", 0, 0, "0.0.0.0/0", ""]
    "in-01" = ["ingress", "tcp", 9000, 9000, local.operations_vpc_cidr_block, "[SONARQUBE-]_OPS-VPC"]
    "in-02" = ["ingress", "tcp", 5432, 5432, local.operations_vpc_cidr_block, "[SONARQUBE-]_OPS-VPC"]
    "in-03" = ["ingress", "tcp", 9300, 9300, local.operations_vpc_cidr_block, "[ELASTICSEARCH-]_OPS-VPC"]
    "in-04" = ["ingress", "tcp", 443, 443, local.operations_vpc_cidr_block, "[HTTPS]_OPS-VPC"]
  }
  sg_rules = {
    "in-01" = ["ingress", "tcp", 0, 0, module.sq-sg.id, "[ALL_TRAFFIC]_SELF"]
  }
}



