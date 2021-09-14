##################################################################################
# OUTPUT
##################################################################################

output "aws_rdb_endpoint" {
    value = aws_db_instance.db.endpoint
}

output "aws_ec2_dns" {
    value = aws_instance.ec2.public_dns
}
