variable "env" {
  description = "an abbreviated form of the name of the environment"
  type        = string
  default     = "SS"

  validation {
    condition     = contains(["SS", "DEV"], var.env)
    error_message = "Environment must be either 'UAT' or 'PRD'."
  }
}
variable "aws_access_key" {
}
variable "aws_secret_key" {
}

variable "rds_sonar_password" {

}

variable "rds_sonar_username" {

}
variable "region" {
  default = "us-east-1"
}

