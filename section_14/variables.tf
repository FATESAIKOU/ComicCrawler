######################################################################
# VARIABLES
######################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "db_username" {
    default = "db_username"
}

variable "db_password" {
    default = "db_password" # Should be longer than 8 characters
}

variable "region" {
    default = "ap-northeast-1"
}

variable "network_address_space" {
    default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
    default = "10.1.0.0/24"
}

variable "subnet2_address_space" {
    default = "10.1.1.0/24"
}

variable "subnet_private_address_space" {
    default = "10.1.2.0/24"
}
