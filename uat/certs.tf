#module "bal-acm" {
#  source  = "../modules/acm"
#  
#  domain_name  =  "balfourcare-uat.welltowercloud.com"
#  zone_id      = data.aws_route53_zone.ops_zone.zone_id #module.zones.route53_zone_zone_id["uat.wellops4500.com"]  #module.zones.route53_zone_zone_id["test.faf.us.com"]  #data.aws_route53_zone.zone.zone_id
#
# # subject_alternative_names = [
# # ]
#
#  wait_for_validation = true
#
#  tags = {
#    Name = "balfour"
#  }
#}
#module "brandywine-acm" {
#  source  = "../modules/acm"
#  
#  domain_name  =  "brandywine-uat.welltowercloud.com"
#  zone_id      = data.aws_route53_zone.ops_zone.zone_id #module.zones.route53_zone_zone_id["uat.wellops4500.com"]  #module.zones.route53_zone_zone_id["test.faf.us.com"]  #data.aws_route53_zone.zone.zone_id
#
# # subject_alternative_names = [
# # ]
#
#  wait_for_validation = true
#
#  tags = {
#    Name = "brandywine"
#  }
#}

#module "bal-palisades-acm" {
#  source  = "../modules/acm"
#  
#  domain_name  =  "balpalisades-uat.welltowercloud.com"
#  zone_id      = data.aws_route53_zone.ops_zone.zone_id #module.zones.route53_zone_zone_id["uat.wellops4500.com"]  #module.zones.route53_zone_zone_id["test.faf.us.com"]  #data.aws_route53_zone.zone.zone_id
#
# # subject_alternative_names = [
# # ]
#
#  wait_for_validation = true
#
#  tags = {
#    Name = "balpalisades"
#  }
#}