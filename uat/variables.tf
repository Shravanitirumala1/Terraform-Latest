variable "env" {
  description = "an abbreviated form of the name of the environment"
  type        = string
  default     = "uat"
  validation {
    condition     = contains(["uat", "dev"], var.env)
    error_message = "Environment must be either 'UAT' or 'PRD'."
  }
}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "ops_aws_access_key" {}
variable "ops_aws_secret_key" {}
variable "region" {
  default = "us-east-1"
}

####ES#####
variable "search_username" {
  default = ""
}
variable "search_password" {
  default = ""
}
variable "domain_name" {

  default = "st-search-uat"
}
variable "whitelist" {
  default = []
}
#####EKS####

variable "create" {
  description = "Determines whether to create self managed node group or not"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "platform" {
  description = "Identifies if the OS platform is `bottlerocket`, `linux`, or `windows` based"
  type        = string
  default     = "linux"
}

##############CDN################
variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
  type        = string
  default     = "arn:aws:wafv2:us-east-1:358646388167:global/webacl/IMPERVA-UAT/bc7f49b4-fbfb-4af9-8948-c4f39ad4c11a"
}