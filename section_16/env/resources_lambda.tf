##################################################################################
# RESOURCES
##################################################################################

# Lambda
resource "aws_lambda_function" "test_lambda" {
    function_name = "test_lambda"

    role = aws_iam_role.test_lambda_role.arn

    timeout = 900
    memory_size = 1024

    image_uri = "${aws_ecr_repository.repo.repository_url}@${data.aws_ecr_image.lambda_image.id}"
    package_type = "Image"

    environment {
        variables = {
            db_host     = element(split(":", aws_db_instance.db.endpoint), 0)
            db_port     = element(split(":", aws_db_instance.db.endpoint), 1)
            db_user     = var.db_username
            db_pass     = var.db_password
        }
    }
}

resource "aws_iam_role" "test_lambda_role" {
    name = "test_lambda_role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.test_lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Cloud watch
resource "aws_cloudwatch_event_rule" "every_one_hour" {
    name = "test-every-one-hour"
    description = "for test"
    schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "call_lambda_every_one_hour" {
    rule = aws_cloudwatch_event_rule.every_one_hour.name
    target_id = "test_lambda"
    arn = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.test_lambda.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_one_hour.arn
}
