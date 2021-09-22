##################################################################################
# OUTPUT
##################################################################################

output "db_host" {
    value = element(split(":", aws_db_instance.db.endpoint), 0)
}

output "db_port" {
    value = element(split(":", aws_db_instance.db.endpoint), 1)
}

output "db_name" {
    value = "comicdb"
}

output "db_user" {
    value = var.db_username
}

output "db_pass" {
    value = var.db_password
}

output "aws_ec2_dns" {
    value = aws_instance.ec2.public_dns
}
