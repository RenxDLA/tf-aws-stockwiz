data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/src/lambda.py"
  output_path = "${path.module}/src/lambda.zip"
}

data "aws_iam_role" "lab_role"{
    name = "LabRole"
}