##################################################################################
# OUTPUT
##################################################################################

output "aws_ec2_dns" {
    value = aws_instance.backend-ec2.public_dns
}

output "index_html_url" {
    value = "https://${aws_s3_bucket.frontend-bucket.bucket_domain_name}/${aws_s3_bucket_object.html.id}"
}
