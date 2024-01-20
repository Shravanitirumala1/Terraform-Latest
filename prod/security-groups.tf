locals {
  uat_vpc_cidr_block = "172.22.32.0/19"
  ops_vpc_cidr_block = "172.22.128.0/19"
  imperva_cidr_1     = "199.83.128.0/21"
  imperva_cidr_2     = "198.143.32.0/19"
  imperva_cidr_3     = "149.126.72.0/21"
  imperva_cidr_4     = "103.28.248.0/22"
  imperva_cidr_5     = "45.64.64.0/22"
  imperva_cidr_6     = "185.11.124.0/22"
  imperva_cidr_7     = "192.230.64.0/18"
  imperva_cidr_8     = "107.154.0.0/16"
  imperva_cidr_9     = "45.60.0.0/16"
  imperva_cidr_10    = "45.223.0.0/16"
  imperva_cidr_11    = "131.125.128.0/17"
}


module "es-sg" {
  source      = "../modules/security-group"
  name        = "ST-SEARCH-SG"
  vpc_id      = module.vpc.vpc
  description = "SEARCH SG"
  cidr_rules = {
    "out"   = ["egress", "all", 0, 0, "0.0.0.0/0", ""]
    "in-01" = ["ingress", "tcp", 80, 80, local.uat_vpc_cidr_block, "[HTTP]_UAT-VPC"]
    "in-02" = ["ingress", "tcp", 9300, 9300, local.uat_vpc_cidr_block, "[ELASTICSEARCH-]_UAT-VPC"]
    "in-03" = ["ingress", "tcp", 443, 443, local.uat_vpc_cidr_block, "[HTTPS]_UAT-VPC"]
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
    "in-01" = ["ingress", "tcp", 22, 22, local.uat_vpc_cidr_block, "[HTTP]_UAT-VPC"]
    "in-02" = ["ingress", "tcp", 80, 80, local.imperva_cidr_1, "[IMPERVA]-WAF"]
    "in-03" = ["ingress", "tcp", 80, 80, local.imperva_cidr_2, "[IMPERVA]-WAF"]
    "in-04" = ["ingress", "tcp", 80, 80, local.imperva_cidr_3, "[IMPERVA]-WAF"]
    "in-05" = ["ingress", "tcp", 80, 80, local.imperva_cidr_4, "[IMPERVA]-WAF"]
    "in-06" = ["ingress", "tcp", 80, 80, local.imperva_cidr_5, "[IMPERVA]-WAF"]
    "in-07" = ["ingress", "tcp", 80, 80, local.imperva_cidr_6, "[IMPERVA]-WAF"]
    "in-08" = ["ingress", "tcp", 80, 80, local.imperva_cidr_7, "[IMPERVA]-WAF"]
    "in-09" = ["ingress", "tcp", 80, 80, local.imperva_cidr_8, "[IMPERVA]-WAF"]
    "in-10" = ["ingress", "tcp", 80, 80, local.imperva_cidr_9, "[IMPERVA]-WAF"]
    "in-11" = ["ingress", "tcp", 80, 80, local.imperva_cidr_10, "[IMPERVA]-WAF"]
    "in-12" = ["ingress", "tcp", 80, 80, local.imperva_cidr_11, "[IMPERVA]-WAF"]
    "in-13" = ["ingress", "tcp", 443, 443, local.imperva_cidr_1, "[IMPERVA]-WAF"]
    "in-14" = ["ingress", "tcp", 443, 443, local.imperva_cidr_2, "[IMPERVA]-WAF"]
    "in-15" = ["ingress", "tcp", 443, 443, local.imperva_cidr_3, "[IMPERVA]-WAF"]
    "in-16" = ["ingress", "tcp", 443, 443, local.imperva_cidr_4, "[IMPERVA]-WAF"]
    "in-17" = ["ingress", "tcp", 443, 443, local.imperva_cidr_5, "[IMPERVA]-WAF"]
    "in-18" = ["ingress", "tcp", 443, 443, local.imperva_cidr_6, "[IMPERVA]-WAF"]
    "in-19" = ["ingress", "tcp", 443, 443, local.imperva_cidr_7, "[IMPERVA]-WAF"]
    "in-20" = ["ingress", "tcp", 443, 443, local.imperva_cidr_8, "[IMPERVA]-WAF"]
    "in-21" = ["ingress", "tcp", 443, 443, local.imperva_cidr_9, "[IMPERVA]-WAF"]
    "in-22" = ["ingress", "tcp", 443, 443, local.imperva_cidr_10, "[IMPERVA]-WAF"]
    "in-23" = ["ingress", "tcp", 443, 443, local.imperva_cidr_11, "[IMPERVA]-WAF"]
    #"in-24" = ["ingress", "tcp", 443, 443, local.imperva_cidr_12, "[IMPERVA]-WAF"]
  }
  sg_rules = {
    "in-01" = ["ingress", "tcp", 0, 0, module.eks-sg.id, "[ALL_TRAFFIC]_SELF"]
  }
}

#module "imperva-sg" {
#  source      = "../modules/security-group"
#  name        = "IMERVA-SG"
#  vpc_id      = module.vpc.vpc
#  description = "EKS SG"
#  cidr_rules = {
#    "out" = ["egress", "all", 0, 0, "0.0.0.0/0", ""]
#	"in-01" = ["ingress", "tcp", 22, 22, local.uat_vpc_cidr_block, "[HTTP]_UAT-VPC"]
#  "in-02" = ["ingress", "tcp", 80, 80, local.imperva_cidr_1, "[IMPERVA]-WAF"]
#  "in-03" = ["ingress", "tcp", 80, 80, local.imperva_cidr_2, "[IMPERVA]-WAF"]
#  "in-04" = ["ingress", "tcp", 80, 80, local.imperva_cidr_3, "[IMPERVA]-WAF"]
#  "in-05" = ["ingress", "tcp", 80, 80, local.imperva_cidr_4, "[IMPERVA]-WAF"]
#  "in-06" = ["ingress", "tcp", 80, 80, local.imperva_cidr_5, "[IMPERVA]-WAF"]
#  "in-07" = ["ingress", "tcp", 80, 80, local.imperva_cidr_6, "[IMPERVA]-WAF"]
#  "in-08" = ["ingress", "tcp", 80, 80, local.imperva_cidr_7, "[IMPERVA]-WAF"]
#  "in-09" = ["ingress", "tcp", 80, 80, local.imperva_cidr_8, "[IMPERVA]-WAF"]
#  "in-10" = ["ingress", "tcp", 80, 80, local.imperva_cidr_9, "[IMPERVA]-WAF"]
#  "in-11" = ["ingress", "tcp", 80, 80, local.imperva_cidr_10, "[IMPERVA]-WAF"]
#  "in-12" = ["ingress", "tcp", 80, 80, local.imperva_cidr_11, "[IMPERVA]-WAF"]
#  "in-13" = ["ingress", "tcp", 443, 443, local.imperva_cidr_1, "[IMPERVA]-WAF"]
#  "in-14" = ["ingress", "tcp", 443, 443, local.imperva_cidr_2, "[IMPERVA]-WAF"]
#  "in-15" = ["ingress", "tcp", 443, 443, local.imperva_cidr_3, "[IMPERVA]-WAF"]
#  "in-16" = ["ingress", "tcp", 443, 443, local.imperva_cidr_4, "[IMPERVA]-WAF"]
#  "in-17" = ["ingress", "tcp", 443, 443, local.imperva_cidr_5, "[IMPERVA]-WAF"]
#  "in-18" = ["ingress", "tcp", 443, 443, local.imperva_cidr_6, "[IMPERVA]-WAF"]
#  "in-19" = ["ingress", "tcp", 443, 443, local.imperva_cidr_7, "[IMPERVA]-WAF"]
#  "in-20" = ["ingress", "tcp", 443, 443, local.imperva_cidr_8, "[IMPERVA]-WAF"]
#  "in-21" = ["ingress", "tcp", 443, 443, local.imperva_cidr_9, "[IMPERVA]-WAF"]
#  "in-22" = ["ingress", "tcp", 443, 443, local.imperva_cidr_10, "[IMPERVA]-WAF"]
#  "in-23" = ["ingress", "tcp", 443, 443, local.imperva_cidr_11, "[IMPERVA]-WAF"]
#  "in-24" = ["ingress", "tcp", 443, 443, "0.0.0.0/0", "[IMPERVA]-WAF"]
#  "in-25" = ["ingress", "tcp", 80, 80, "0.0.0.0/0", "[IMPERVA]-WAF"]
#  }
#	sg_rules = {
#  "in-01" = ["ingress", "tcp", 0, 0, module.imperva-sg.id, "[ALL_TRAFFIC]_SELF"]
#  }
#}

