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
  name            = "st-eks-prod"
  cluster_version = "1.25"
  region          = "us-east-1"

  vpc_cidr = module.vpc.vpc #"172.22.64.0/19"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    name        = local.name
    environment = "prod"
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
  cluster_endpoint_public_access_cidrs = ["67.202.24.21/32", "174.72.47.222/32", "103.140.231.217/32", "69.215.230.52/32", "70.95.199.10/32", "73.145.39.214/32", "165.225.61.67/32"] #10.100.120.83/32"]
  cluster_addons = {
    coredns = {
      preserve    = true
      most_recent = true
    }
    kube-proxy = {
      preserve    = true
      most_recent = true
    }
    vpc-cni = {
      preserve    = true
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc                                                                                         #"vpc-085aaf4a6092e1bb9"
  subnet_ids = [module.vpc.private_subnets[0].id, module.vpc.private_subnets[1].id, module.vpc.private_subnets[3].id] #["subnet-01071e6d4ff366a5e","subnet-07613612aebcacf10"]
  #control_plane_subnet_ids = module.vpc.intra_subnets

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  # create_aws_auth_configmap = true
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::602837221957:role/AWSReservedSSO_AdministratorAccess_efa505aa3a0bcacd"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::602837221957:role/Cross-Account-Ops-Role"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
  ]


  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    instance_types                        = ["m5.xlarge"] ##"m6i.large", "m5zn.large", "m5n.large", 
    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [module.eks-sg.id]
    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn
    }
  }
  eks_managed_node_groups = {
    node-group-prod-1 = {
      min_size                = 1
      max_size                = 2
      desired_size            = 1
      instance_types          = ["m5.xlarge"]
      capacity_type           = "ON_DEMAND"
      key_name                = data.aws_key_pair.prod.key_name
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
      #disk_size = 100
      labels = {
      Environment = "prod" }

    }
    node-group-prod-2 = {
      min_size                = 1
      max_size                = 2
      desired_size            = 1
      key_name                = data.aws_key_pair.prod.key_name
      instance_types          = ["m5.xlarge"]
      capacity_type           = "ON_DEMAND"
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
      disk_size = 100
      labels = {
      Environment = "prod" }
    }
    # green = {
    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1
    #   instance_types = ["t3.large"]
    #   capacity_type  = "SPOT"
    #    labels = {
    #      Environment = "prod"
    #      
    #    }
    #
    #    taints = {
    #      dedicated = {
    #        key    = "dedicated"
    #        value  = "gpuGroup"
    #        effect = "NO_SCHEDULE"
    #      }
    #    }
    #
    #    update_config = {
    #      max_unavailable_percentage = 33 # or set `max_unavailable`
    #    }
    #
    #    tags = {
    #      Environment = "prod"
    #    }
    #  }
  }
  #self_managed_node_group_defaults = {
  #  # enable discovery of autoscaling groups by cluster-autoscaler
  #  autoscaling_group_tags = {
  #    "k8s.io/cluster-autoscaler/enabled" : true,
  #    "k8s.io/cluster-autoscaler/${local.name}" : "owned",
  #  }
  #}
  #
  #self_managed_node_groups = {
  #  # Default node group - as provisioned by the module defaults
  # # default_node_group = {}
  #
  #  # st-eks-prod node group
  #  st-eks-prod = {
  #    name = "st-eks-prod-self-mng"
  #
  #    platform      = "st-eks-prod"
  #    ami_id        = data.aws_ami.eks_default.id #data.aws_ami.eks_default_st-eks-prod.id
  #    instance_type = "m5.large"
  #    desired_size  = 1
  #    key_name      = data.aws_key_pair.prod.key_name #module.key_pair.key_pair_name
  #
  #    bootstrap_extra_args = <<-EOT
  #      # The admin host container provides SSH access and runs with "superpowers".
  #      # It is disabled by default, but can be disabled explicitly.
  #      [settings.host-containers.admin]
  #      enabled = false
  #
  #      # The control host container provides out-of-band access via SSM.
  #      # It is enabled by default, and can be disabled if you do not expect to use SSM.
  #      # This could leave you with no way to access the API and change settings on an existing node!
  #      [settings.host-containers.control]
  #      enabled = true
  #
  #      # extra args added
  #      [settings.kernel]
  #      lockdown = "integrity"
  #
  #      [settings.kubernetes.node-labels]
  #      label1 = "foo"
  #      label2 = "bar"
  #
  #      #[settings.kubernetes.node-taints]
  #      #dedicated = "experimental:PreferNoSchedule"
  #      #special = "false:NoSchedule"
  #    EOT
  #  }
  ## Complete
  #complete = {
  #  name            = "complete-self-mng"
  #  use_name_prefix = false
  #
  #  subnet_ids = module.vpc.public_subnets
  #
  #  min_size     = 1
  #  max_size     = 2
  #  desired_size = 1
  #
  #  ami_id               = data.aws_ami.eks_default.id
  #  bootstrap_extra_args = "--kubelet-extra-args '--max-pods=110'"
  #
  #  pre_bootstrap_user_data = <<-EOT
  #    export CONTAINER_RUNTIME="containerd"
  #    export USE_MAX_PODS=false
  #  EOT
  #
  #  post_bootstrap_user_data = <<-EOT
  #    echo "you are free little kubelet!"
  #  EOT
  #
  #  instance_type = "m6i.large"
  #
  #  launch_template_name            = "self-managed-ex"
  #  launch_template_use_name_prefix = true
  #  launch_template_description     = "Self managed node group example launch template"
  #
  #  ebs_optimized     = true
  #  enable_monitoring = true
  #
  #  block_device_mappings = {
  #    xvda = {
  #      device_name = "/dev/xvda"
  #      ebs = {
  #        volume_size           = 75
  #        volume_type           = "gp3"
  #        iops                  = 3000
  #        throughput            = 150
  #        encrypted             = true
  #        kms_key_id            = module.ebs_kms_key.key_arn
  #        delete_on_termination = true
  #      }
  #    }
  #  }
  #
  #  metadata_options = {
  #    http_endpoint               = "enabled"
  #    http_tokens                 = "required"
  #    http_put_response_hop_limit = 2
  #    instance_metadata_tags      = "disabled"
  #  }
  #
  #  capacity_reservation_specification = {
  #    capacity_reservation_target = {
  #      capacity_reservation_id = aws_ec2_capacity_reservation.targeted.id
  #    }
  #  }
  #
  #  create_iam_role          = true
  #  iam_role_name            = "self-managed-node-group-complete-example"
  #  iam_role_use_name_prefix = false
  #  iam_role_description     = "Self managed node group complete example role"
  #  iam_role_tags = {
  #    Purpose = "Protector of the kubelet"
  #  }
  #  iam_role_additional_policies = {
  #    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  #    additional                         = aws_iam_policy.additional.arn
  #  }
  #
  #  timeouts = {
  #    create = "80m"
  #    update = "80m"
  #    delete = "80m"
  #  }
  #
  #  tags = {
  #    ExtraTag = "Self managed node group complete example"
  #  }
  #}
  #  }
  #
  #  tags = local.tags
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

#data "aws_ami" "eks_default_st-eks-prod" {
#  most_recent = true
#  owners      = ["amazon"]
#
#  filter {
#    name   = "name"
#    values = ["st-eks-prod-aws-k8s-${local.cluster_version}-x86_64-*"]
#  }
#}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = local.name
  create_private_key = true

  tags = local.tags
}

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
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = local.tags
}
