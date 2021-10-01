##################################################################################
# RESOURCES
##################################################################################

# Lambda
resource "aws_lambda_function" "test_lambda" {
    function_name = "test_lambda"

    role = aws_iam_role.test_lambda_role.arn

    timeout = 15
    memory_size = 128

    image_uri = "${aws_ecr_repository.repo.repository_url}@${data.aws_ecr_image.lambda_image.id}"
    package_type = "Image"
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
