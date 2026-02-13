resource "aws_api_gateway_rest_api" "user_api" {
  name        = "cloud-user-api"
  description = "API for managing user data"
}

# -------------------------
# USERS RESOURCE
# -------------------------

resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.user_api.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.user_pool.arn]
  identity_source = "method.request.header.Authorization"
}


resource "aws_api_gateway_method" "post_users" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_users_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.post_users.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.user_data_lambda.invoke_arn
}

# -------------------------
# PREFERENCES RESOURCE
# -------------------------

resource "aws_api_gateway_resource" "preferences" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "preferences"
}

resource "aws_api_gateway_method" "post_preferences" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.preferences.id
  http_method   = "POST"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "post_preferences_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.preferences.id
  http_method = aws_api_gateway_method.post_preferences.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.store_preferences_lambda.invoke_arn
}

# -------------------------
# LAMBDA PERMISSIONS
# -------------------------

resource "aws_lambda_permission" "allow_apigateway_invoke_users" {
  statement_id  = "AllowAPIGatewayInvokeUsers"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_data_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/POST/users"
}

resource "aws_lambda_permission" "allow_apigateway_invoke_preferences" {
  statement_id  = "AllowAPIGatewayInvokePreferences"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.store_preferences_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/POST/preferences"
}

# -------------------------
# DEPLOYMENT + STAGE
# -------------------------

  resource "aws_api_gateway_deployment" "user_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users.id,
      aws_api_gateway_resource.preferences.id,
      aws_api_gateway_method.post_users.id,
      aws_api_gateway_method.post_preferences.id,
      aws_api_gateway_integration.post_users_lambda.id,
      aws_api_gateway_integration.post_preferences_lambda.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  deployment_id = aws_api_gateway_deployment.user_api_deployment.id
  stage_name    = "dev"
}
