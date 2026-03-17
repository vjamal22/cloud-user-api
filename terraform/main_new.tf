resource "aws_lambda_function" "plan_generator" {
function_name = "fitness-plan-generator"

filename         = "../Lambda/plan_generator.zip"
source_code_hash = filebase64sha256("../Lambda/plan_generator.zip")

handler = "plan_generator.lambda_handler"
runtime = "python3.11"

role = aws_iam_role.lambda_execution_role.arn

timeout = 30
}

