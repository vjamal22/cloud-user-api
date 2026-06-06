resource "aws_lambda_function" "plan_generator" {
  function_name = "fitness-plan-generator"

  filename         = "../Lambda/plan_generator.zip"
  source_code_hash = filebase64sha256("../Lambda/plan_generator.zip")

  handler = "plan_generator.lambda_handler"
  runtime = "python3.11"

  role = aws_iam_role.lambda_execution_role.arn

  timeout = 30
}
resource "aws_lambda_function" "upload_request" {
  function_name = "upload-request"

  filename         = "../Lambda/lambdas/upload-request.zip"
  source_code_hash = filebase64sha256("../Lambda/lambdas/upload-request.zip")

  handler = "index.lambda_handler"
  runtime = "python3.11"

  role = aws_iam_role.lambda_execution_role.arn

  timeout = 10
}

resource "aws_lambda_function" "generate_upload_url" {
  function_name = "generate-upload-url"

  filename         = "../Lambda/lambdas/generate-upload-url.zip"
  source_code_hash = filebase64sha256("../Lambda/lambdas/generate-upload-url.zip")

  handler = "index.lambda_handler"
  runtime = "python3.11"

  role = aws_iam_role.lambda_execution_role.arn

  timeout = 10
}