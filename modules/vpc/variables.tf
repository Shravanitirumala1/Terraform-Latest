variable "vpc_config" {
  description = "an object containing config parameters for the vpc"
  type = object({
    name                      = string,
    cidr_block                = string,
    additional_cidr_blocks    = list(string),
    public_subnets            = list(map(string)),
    public_route_table_name   = string,
    private_subnets           = list(map(string)),
    private_route_table_names = list(string),
    nacl_name                 = string,
    igw_name                  = string
  })

}
variable "tags" {
  description = "A map of additional tags to add"
  type        = map(string)
  default     = {}
}
variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}
variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}