######################################################################
# DATA
######################################################################

data aws_caller_identity current {}

data aws_ecr_image lambda_image {
    depends_on = [
        null_resource.ecr_image
    ]
    repository_name = local.ecr_repository_name
    image_tag       = local.ecr_image_tag
}

data archive_file src {
    type        = "zip"
    output_path = "src.zip"
    count       = "1"
    source_dir  = "${local.src_dirs[count.index]}"
}

######################################################################
# LOCALS
######################################################################

locals {
    prefix = "lambda-ecr-test"
    account_id          = data.aws_caller_identity.current.account_id
    ecr_repository_name = "${local.prefix}-image"
    ecr_image_tag       = "latest"
    src_dirs             = ["${path.module}/src"]
}

######################################################################
# RESOURCES
######################################################################

resource aws_ecr_repository repo {
    name = local.ecr_repository_name
}

resource null_resource ecr_image {
    triggers = {
        docker_file = md5(file("${path.module}/dockerfile")),
        src_hash    = "${data.archive_file.src[0].output_sha}"
    }

    provisioner "local-exec" {
        command = <<EOF
            aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com
            cd ${path.module}
            docker build --build-arg MAIN_PY="${local.src_dirs[0]}/lambda_main.py" \
                --no-cache -t ${aws_ecr_repository.repo.repository_url}:${local.ecr_image_tag} .
            docker push ${aws_ecr_repository.repo.repository_url}:${local.ecr_image_tag}
        EOF
    }
}


######################################################################
# OUTPUT
######################################################################

output "image_id" {
    value = data.aws_ecr_image.lambda_image.id
}