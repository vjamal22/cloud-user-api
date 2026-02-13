# -----------------------------
# DynamoDB Table - user_profiles
# -----------------------------
resource "aws_dynamodb_table" "user_profiles" {
  name         = "user_profiles"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

# -----------------------------
# DynamoDB Table - user_preferences
# -----------------------------
resource "aws_dynamodb_table" "user_preferences" {
  name         = "user_preferences"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name        = "user_preferences"
    Environment = "dev"
    Project     = "fitness-experience"
  }
}

# -----------------------------
# IAM Role for Lambda
# -----------------------------
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# -----------------------------
# IAM Policy for Lambda (user_profiles table)
# -----------------------------
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "lambda_dynamodb_policy"
  description = "Allow Lambda to write logs and access DynamoDB user_profiles table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.user_profiles.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# -----------------------------
# IAM Policy for user_preferences Lambda
# -----------------------------
resource "aws_iam_policy" "preferences_dynamodb_policy" {
  name        = "preferences_dynamodb_policy"
  description = "Allow Lambda to write to user_preferences DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.user_preferences.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "preferences_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.preferences_dynamodb_policy.arn
}

# -----------------------------
# Lambda Function - user_data_handler
# -----------------------------
resource "aws_lambda_function" "user_data_lambda" {
  function_name = "user-data-handler"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  filename         = "../Lambda/lambda_function_payload.zip"
  source_code_hash = filebase64sha256("../Lambda/lambda_function_payload.zip")

  role = aws_iam_role.lambda_execution_role.arn
}

# -----------------------------
# Lambda Function - store_preferences
# -----------------------------
resource "aws_lambda_function" "store_preferences_lambda" {
  function_name = "store-preferences-handler"
  handler       = "store_preferences.lambda_handler"
  runtime       = "python3.11"

  filename         = "../Lambda/store_preferences_payload.zip"
  source_code_hash = filebase64sha256("../Lambda/store_preferences_payload.zip")

  role = aws_iam_role.lambda_execution_role.arn

  # Environment variable for table name
  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.user_preferences.name
    }
  }
}
