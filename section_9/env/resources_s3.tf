##################################################################################
# RESOURCES
##################################################################################

resource "aws_s3_bucket" "frontend-bucket" {
    bucket = var.bucket_name
    acl = "private"   # or can be "public-read"
}

module "new_index_html" {
    source  = "matti/resource/shell"
    command = "sed 's/YOUREC2DNS/${aws_instance.backend-ec2.public_dns}/' '${path.module}/../index.html' | tee > /tmp/index.html"
}

resource "aws_s3_bucket_object" "html" {
    bucket = aws_s3_bucket.frontend-bucket.id
    key = "index.html"
    acl = "public-read"

    source = "/tmp/index.html"
    content_type = "text/html"

    etag = md5(module.new_index_html.stdout)
}
