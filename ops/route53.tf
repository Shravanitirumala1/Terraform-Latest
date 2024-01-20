#locals {
#  zone_name = sort(keys(module.zones.route53_zone_name))[0]
#  #  zone_id = module.zones.route53_zone_zone_id["app.terraform-aws-modules-example.com"]
#}
#module "zones" {
#  source  = "../modules/route53/modules/zones"
#  zones = {
#      "welltowercloud.com" = {
#      comment = "welltowercloud.com"
#      vpc = [
#        {
#          vpc_id = module.vpc.vpc
#        },
#      ]
#      tags = {
#        env = "Operations"
#      }
#    }
#  }
#  tags = {
#    ManagedBy = "Terraform"
#  }
#}
## module "sq_route53" {
#   source = "../modules/route53"

#   aliases         = ["sq."]
#   parent_zone_id  = module.zones.route53_zone_zone_id["ss.faf.us.com"] #data.aws_route53_zone.zone.zone_id
#   target_dns_name = module.sq_alb.dns_name
#   target_zone_id  = module.sq_alb.zone_id
# }

# #module "sqs_route53" {
#  # source = "../modules/route53"

#  # aliases         = ["sqs."]
#  # parent_zone_id  = data.aws_route53_zone.zone.zone_id#"Z07611652GAJYDMS0HEYU"
#  # target_dns_name = module.sq_alb.dns_name
#  # target_zone_id  = module.sq_alb.zone_id
#  #}

# module "test_route53" {
#   source = "../modules/route53/modules/records"
#   zone_name = data.aws_route53_zone.zone.name
#   records = [
#       {
#       name           = "sts"
#       type           = "A"
#       alias = {
#         name    = module.sq_alb.dns_name
#         zone_id = module.sq_alb.zone_id
#       }
#     }
#   ]
#   depends_on = [module.zones]
# }
# #  aliases         = ["sqs."]
# #  parent_zone_id  = module.
# #  target_dns_name = module.sq_alb.dns_name
# #  target_zone_id  = module.sq_alb.zone_id
# #}

# #module "zones" {
# #  source      = "../modules/route53/modules/zones"
# #  zones = {
# #    
# #
# #    "ss" = {
# #      # in case than private and public zones with the same domain name
# #      domain_name = "ss.faf.us.com"
# #      comment     = "ss.faf.us.com"
# #      vpc = [
# #        {
# #          vpc_id = module.vpc.vpc
# #        },
# #      ]
# #      tags = {
# #        Name = "ss.faf.us.com"
# #      }
# #    }
# #  }
# #
# #  tags = {
# #    environment = "Shared services"
# #  }
# #}
# #
# ##module "records" {
# ##  source = "../modules/route53/modules/records"
# ##
# ##  #zone_name = local.zone_name
# ##    zone_id = local.zone_id
# ##
# ##  records = [
# ##    {
# ##      name           = "sq"
# ##      type           = "CNAME"
# ##      ttl            = 5
# ##      records        = [module.es.endpoint]
# ##      
# ##    },
# ##  ]
# ##
# ##  depends_on = [module.zones]
# ##}
# #module "sq" {
# #  source = "../modules/route53"
# #  
# #  aliases         = ["sq.ss.faf.us.com."]
# #  parent_zone_id  = module.zones.ss.zone_id
# #  target_dns_name = module.sq_alb.dns_name
# #  target_zone_id  = module.sq_alb.zone_id
# #}