provider "aws" {
  region  = var.region
  profile = "udacity"
}
# Create IAM Role
resource "aws_iam_role" "lambda_deploy_role" {
  name = "LambdaDeployRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# Create IAM Policy
resource "aws_iam_policy" "lamda_deploy_logging_policy" {

  name        = "lamda_deploy_logging_policy"
  path        = "/"
  description = "Logging policy for lambda logging "
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "deploy_lambda_logging" {
  role       = aws_iam_role.lambda_deploy_role.name
  policy_arn = aws_iam_policy.lamda_deploy_logging_policy.arn
}

# Archive sourcode
data "archive_file" "archive_sourcode" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = var.archive_path
}

# Create Lambda function
resource "aws_lambda_function" "greet_lambda" {
  filename         = var.archive_path
  function_name    = "greet_lambda"
  role             = aws_iam_role.lambda_deploy_role.arn
  handler          = "greet_lambda.lambda_handler"
  runtime          = var.runtime
  source_code_hash = data.archive_file.archive_sourcode.output_base64sha256
  depends_on       = [aws_iam_role_policy_attachment.deploy_lambda_logging]
  environment {
    variables = {
      "greeting" = var.greeting_msg
    }
  }
}
