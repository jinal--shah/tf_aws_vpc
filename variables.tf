# vim: et sw=4 ts-4 sr smartindent:
variable "aws_tags_name"       { type = "string" }
variable "aws_tags_env"        { type = "string" }
variable "aws_tags_service"    { type = "string" }
variable "aws_tags_build_num"  { type = "string" }

variable "azs"  { type = "string" }
variable "cidr" { type = "string" }
variable "name" { type = "string" }

variable "public_subnets" {
    type    = "string"
    default = ""
}

variable "private_subnets" {
    type    = "string"
    default = ""
}

variable "enable_dns_hostnames" {
    type        = "string"
    description = "should be true if you want to use private DNS within the VPC"
    default     = false
}

variable "enable_dns_support" {
    type        = "string"
    description = "should be true if you want to use private DNS within the VPC"
    default     = false
}

