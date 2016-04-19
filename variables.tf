variable "name" { }
variable "cidr" { }
variable "public_subnets" { default = "" }
variable "private_subnets" { default = "" }
variable "azs" { }
variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}
variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default = false
}

variable "vpc_tags" {
    type    = "map"
    default = {
        Name        = "jin_prod-notifications-0.0.1"
        Environment = "prod"
        Service     = "notifications"
        Build       = "0.0.1"
    }
}
