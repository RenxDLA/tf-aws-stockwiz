# Lambda Function
resource "aws_lambda_function" "ecr_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  function_name = var.lambda_name
  role          = data.aws_iam_role.lab_role.arn
  handler       = var.lambda_handler
  runtime       = var.runtime

  tags = {
    Name    = var.lambda_name
    Creator = "Terraform"
  }
}

# EventBridge Rule to capture ECR PutImage events
resource "aws_cloudwatch_event_rule" "ecr_image_push" {
  name        = "${var.lambda_name}-ecr-push-rule"
  description = "Trigger Lambda when image is pushed to ECR"

  event_pattern = jsonencode({
    source      = ["aws.ecr"]
    detail-type = ["ECR Image Action"]
    detail = {
      action-type = ["PUSH"]
      result      = ["SUCCESS"]
    }
  })

  tags = {
    Name    = "${var.lambda_name}-ecr-push-rule"
    Creator = "Terraform"
  }
}

# EventBridge Target to invoke Lambda
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ecr_image_push.name
  target_id = "lambda"
  arn       = aws_lambda_function.ecr_lambda.arn
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecr_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecr_image_push.arn
}

# Lambda Function URL
resource "aws_lambda_function_url" "ecr_lambda_url" {
  function_name      = aws_lambda_function.ecr_lambda.function_name
  authorization_type = "NONE"
}
