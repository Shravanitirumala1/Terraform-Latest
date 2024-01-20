variable "name" {
  description = "the name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "the id of the vpc that this security group belongs to"
  type        = string
}

variable "description" {
  description = "the description to apply to the security group"
  type        = string
}

variable "cidr_rules" {
  description = "a set of lists that specify the parameters of a security group rule with a cidr as source/dest"
  type        = map(list(any))
  default     = {}
}

variable "sg_rules" {
  description = "a set of lists that specify the parameters of a security group rule with another security group as source/dest"
  type        = map(list(any))
  default     = {}
}

variable "self_rules" {
  description = "a set of lists that specify the parameters of a security group rule with itself as source/dest"
  type        = map(list(any))
  default     = {}
}
