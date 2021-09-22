##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "key_name" {}
variable "private_key_path" {}

variable "db_username" {}
variable "db_password" {}
variable "db_sql_path" {}

variable "proxy_user" {}
variable "proxy_pem_path" {}
variable "proxy_host" {}
variable "proxy_port" {}

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
