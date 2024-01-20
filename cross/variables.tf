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

  default = "wl-search-prod"
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

