#provider "aws" {
#  region = local.region
#}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name            = "st-eks-uat"
  cluster_version = "1.25"
  region          = "us-east-1"

  vpc_cidr = module.vpc.vpc #"172.22.64.0/19"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    name        = local.name
    environment = "uat"
  }
}

################################################################################
## EKS Module#
################################################################################

module "eks" {
  source = "../modules/eks"

  cluster_name                         = local.name
  cluster_version                      = local.cluster_version
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["67.202.24.21/32", "69.215.105.240/32", "69.215.230.52/32", "73.145.39.214/32", "24.52.126.7/32", "165.225.61.67/32"]

  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
      preserve    = true
    }
    vpc-cni = {
      most_recent = true
      preserve    = true
    }
  }

  vpc_id     = module.vpc.vpc                                                       #"vpc-085aaf4a6092e1bb9"
  subnet_ids = [module.vpc.private_subnets[0].id, module.vpc.private_subnets[1].id] #, module.vpc.private_subnets[3].id]#["subnet-01071e6d4ff366a5e","subnet-07613612aebcacf10"]
  #control_plane_subnet_ids = module.vpc.intra_subnets

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  # create_aws_auth_configmap = true
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::358646388167:role/AWSReservedSSO_AdministratorAccess_bfb18e32535cc40b"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::358646388167:role/Cross-Account-Ops-Role"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
  ]
  #aws_auth_node_iam_role_arns_non_windows = [
  #  module.eks_managed_node_group.iam_role_arn,
  #  module.self_managed_node_group.iam_role_arn
  #]
  # aws_auth_roles = [
  #   {
  #     rolearn  = module.self_managed_node_group.iam_role_arn
  #     username = "system:node:{{EC2PrivateDNSName}}"
  #     groups = [
  #       "system:bootstrappers",
  #       "system:nodes",
  #     ]
  #   },
  #   {
  #     rolearn  = "arn:aws:iam::358646388167:role/AWSReservedSSO_AdministratorAccess_bfb18e32535cc40b"
  #     username = "cluster-admin"
  #     groups = [
  #       "system:masters",
  #     ]
  #   },
  #   {
  #     rolearn  = "arn:aws:iam::358646388167:role/AWSReservedSSO_EKSClusterAdminAccess_e00a1645a6f748a5"
  #     username = "cluster-admin"
  #     groups = [
  #       "system:masters",
  #     ]
  #   }
  # ]
  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::005851909592:user/shravanit@tahzoo.com"
  #     username = "shravanit@tahzoo.com"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     userarn  = "arn:aws:iam::005851909592:user/johnl@tahzoo.com"
  #     username = "johnl@tahzoo.com"
  #     groups   = ["system:masters"]
  #   },
  #	{
  #     userarn  = "arn:aws:iam::005851909592:user/dileepk@tahzoo.com"
  #     username = "dileepk@tahzoo.com"
  #     groups   = ["system:masters"]
  #   },
  # ]
  #
  # aws_auth_accounts = [
  #   "005851909592",
  #   "358646388167",
  # ]
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    instance_types                        = ["m5.xlarge"] ##"m6i.large", "m5zn.large", "m5n.large", 
    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [module.eks-sg.id]
    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn #"AmazonEC2RoleforSSM"
    }
  }
  eks_managed_node_groups = {
    node-group-uat-1 = {
      min_size                = 1
      max_size                = 2
      desired_size            = 1
      instance_types          = ["m5.xlarge"]
      capacity_type           = "ON_DEMAND"
      key_name                = "st-uat-eks"
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 150
            volume_type = "gp3"
            iops        = 3000
            throughput  = 150
            encrypted   = false
            #kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
          }
        }
      }
      capacity_type = "ON_DEMAND"

      labels = {
      environment = "uat" }
    }
    node-group-uat-2 = {
      min_size                = 1
      max_size                = 2
      desired_size            = 1
      instance_types          = ["m5.xlarge"]
      capacity_type           = "ON_DEMAND"
      key_name                = "st-uat-eks"
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 150
            volume_type = "gp3"
            iops        = 3000
            throughput  = 150
            encrypted   = false
            #kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
          }
        }
      }
      capacity_type = "ON_DEMAND"

      labels = {
      Environment = "uat" }
    }
  }

  # self_managed_node_group_defaults = {
  #   # enable discovery of autoscaling groups by cluster-autoscaler
  #   autoscaling_group_tags = {
  #     "k8s.io/cluster-autoscaler/enabled" : true,
  #     "k8s.io/cluster-autoscaler/${local.name}" : "owned",
  #   }
  # }

  # self_managed_node_groups = {
  #   # Default node group - as provisioned by the module defaults
  #   default_node_group = {}
  #
  #   # st-eks-uat node group
  #   st-eks-uat = {
  #     name = "st-eks-uat-self-mng-node"
  #
  #     platform      = "st-eks-uat"
  #     ami_id        = data.aws_ami.eks_default.id #data.aws_ami.eks_default_st-eks-uat.id
  #     instance_type = "m5.xlarge"
  #     desired_size  = 1
  #     key_name      = "st-uat-eks" #module.key_pair.key_pair_name
  #
  #     bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"
  #     post_bootstrap_user_data =<<-EOT
  #       cd /tmp
  #       sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  #       sudo systemctl enable amazon-ssm-agent
  #       sudo systemctl start amazon-ssm-agent
  #       # The admin host container provides SSH access and runs with "superpowers".
  #       # It is disabled by default, but can be disabled explicitly.
  #       [settings.host-containers.admin]
  #       enabled = false
  #
  #       # The control host container provides out-of-band access via SSM.
  #       # It is enabled by default, and can be disabled if you do not expect to use SSM.
  #       # This could leave you with no way to access the API and change settings on an existing node!
  #       [settings.host-containers.control]
  #       enabled = true
  #
  #       # extra args added
  #       [settings.kernel]
  #       lockdown = "integrity"
  #
  #       [settings.kubernetes.node-labels]
  #       label1 = "foo"
  #       label2 = "bar"
  #
  #       #[settings.kubernetes.node-taints]
  #       #dedicated = "experimental:PreferNoSchedule"
  #       #special = "false:NoSchedule"
  #     EOT
  #   }


  #}

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "~> 3.0"

#   name = local.name
#   cidr = local.vpc_cidr

#   azs             = local.azs
#   private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
#   public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
#   intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   enable_flow_log                      = true
#   create_flow_log_cloudwatch_iam_role  = true
#   create_flow_log_cloudwatch_log_group = true

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }

#   tags = local.tags
# }

data "aws_ami" "eks_default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-${local.cluster_version}-v*"]
  }
}

#data "aws_ami" "eks_default_st-eks-uat" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["st-eks-uat-aws-k8s-${local.cluster_version}-x86_64-*"]
#  }
#}

#module "key_pair" {
#  source  = "terraform-aws-modules/key-pair/aws"
#  version = "~> 2.0"
#
#  key_name_prefix    = local.name
#  create_private_key = true
#
#  tags = local.tags
#}

module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.1"

  description = "Customer managed key to encrypt EKS managed node group volumes"

  # Policy
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]
  key_service_users = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn,
  ]

  # Aliases
  aliases = ["eks/${local.name}/ebs"]

  tags = local.tags
}

#resource "aws_ec2_capacity_reservation" "targeted" {
#  instance_type           = "m6i.large"
#  instance_platform       = "Linux/UNIX"
#  availability_zone       = "${local.region}a"
#  instance_count          = 1
#  instance_match_criteria = "targeted"
#}

#resource "aws_security_group" "additional" {
#  name_prefix = "${local.name}-additional"
#  vpc_id      = module.vpc.vpc
#
#  ingress {
#    from_port = 22
#    to_port   = 22
#    protocol  = "tcp"
#    cidr_blocks = [
#      "10.0.0.0/8",
#      "172.16.0.0/12",
#      "192.168.0.0/16",
#    ]
#  }
#
#  tags = merge(local.tags, { Name = "${local.name}-additional" })
#}

resource "aws_iam_policy" "additional" {
  name        = "${local.name}-additional"
  description = "Example usage of node additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = local.tags
}
#module "self_managed_node_group" {
#  source = "../modules/eks/modules/self-managed-node-group"
#
#  name                = "separate-self-mng"
#  cluster_name        = module.eks.cluster_name
#  cluster_version     = module.eks.cluster_version
#  cluster_endpoint    = module.eks.cluster_endpoint
#  cluster_auth_base64 = module.eks.cluster_certificate_authority_data
#
#  instance_type = "t3.large"
#
#  subnet_ids = [module.vpc.private_subnets[0].id, module.vpc.private_subnets[1].id] #["subnet-01071e6d4ff366a5e","subnet-07613612aebcacf10"]#module.vpc.private_subnets
#  vpc_security_group_ids = [
#    #module.eks.cluster_primary_security_group_id,
#    #module.eks.cluster_security_group_id,
#    module.es-sg.id
#  ]
#  #self_managed_node_group_defaults = {
#  #  # enable discovery of autoscaling groups by cluster-autoscaler
#  #  autoscaling_group_tags = {
#  #    "k8s.io/cluster-autoscaler/enabled" : true,
#  #    "k8s.io/cluster-autoscaler/${local.name}" : "owned",
#  #  }
#  #}
#
#  tags = merge(local.tags, { Separate = "self-managed-node-group" })
#}
