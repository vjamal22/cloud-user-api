###################################
# DynamoDB Table
###################################

resource "aws_dynamodb_table" "user_profiles" {
  name         = "user_profiles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

###################################
# New DynamoDB Table for Analysis Results
###################################

resource "aws_dynamodb_table" "analysis_results" {
  name         = "analysis_results"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "analysis_id"

  attribute {
    name = "analysis_id"
    type = "S"
  }
}

###################################
# IAM Role for Lambda
###################################

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

###################################
# Lambda Function
###################################

resource "aws_lambda_function" "store_preferences_lambda" {
  function_name = "store-user-preferences"

  filename         = "../Lambda/plan_generator.zip"
  source_code_hash = timestamp()

  handler = "plan_generator.lambda_handler"
  runtime = "python3.11"

  role = aws_iam_role.lambda_exec_role.arn

  timeout = 10
}