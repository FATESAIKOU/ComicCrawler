##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "key_name" {}
variable "private_key_path" {}

variable "comicdb_dir" {}
variable "bucket_name" {}

variable "region" {
    default = "ap-northeast-1"
}

variable "network_address_space" {
    default = "10.1.0.0/16"
}

variable "subnet_address_space" {
    default = "10.1.0.0/24"
}
