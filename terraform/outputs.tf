output "dynamodb_table_name" {
  value = aws_dynamodb_table.user_profiles.name
}

output "lambda_function_name" {
  value = aws_lambda_function.user_data_lambda.function_name
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.user_api.id}.execute-api.us-east-1.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}
