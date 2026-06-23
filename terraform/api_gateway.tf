resource "aws_api_gateway_rest_api" "user_api" {
  name        = "cloud-user-api"
  description = "API for managing user data"
}

# USERS RESOURCE
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "users"
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
  uri                     = aws_lambda_function.store_preferences_lambda.invoke_arn
}

# UPLOAD RESOURCE
resource "aws_api_gateway_resource" "upload" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "post_upload" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.upload.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "upload_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.upload.id
  http_method = aws_api_gateway_method.post_upload.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.upload_request.invoke_arn
}

# GENERATE UPLOAD URL RESOURCE
resource "aws_api_gateway_resource" "generate_upload_url" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "generate-upload-url"
}

resource "aws_api_gateway_method" "post_generate_upload_url" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.generate_upload_url.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_integration" "generate_upload_url_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.generate_upload_url.id
  http_method = aws_api_gateway_method.post_generate_upload_url.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.generate_upload_url.invoke_arn
}

resource "aws_api_gateway_method" "options_generate_upload_url" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.generate_upload_url.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_generate_upload_url_integration" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.generate_upload_url.id
  http_method = aws_api_gateway_method.options_generate_upload_url.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_generate_upload_url_response" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.generate_upload_url.id
  http_method = aws_api_gateway_method.options_generate_upload_url.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_generate_upload_url_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.generate_upload_url.id
  http_method = aws_api_gateway_method.options_generate_upload_url.http_method
  status_code = aws_api_gateway_method_response.options_generate_upload_url_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# OPTIONS /upload
resource "aws_api_gateway_method" "options_upload" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.upload.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_upload_integration" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.upload.id
  http_method = aws_api_gateway_method.options_upload.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_upload_response" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.upload.id
  http_method = aws_api_gateway_method.options_upload.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_upload_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.upload.id
  http_method = aws_api_gateway_method.options_upload.http_method
  status_code = aws_api_gateway_method_response.options_upload_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# AUTHORIZER
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.user_api.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.user_pool.arn]
  identity_source = "method.request.header.Authorization"
}

# PREFERENCES RESOURCE
resource "aws_api_gateway_resource" "preferences" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "preferences"
}

resource "aws_api_gateway_method" "post_preferences" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.preferences.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_preferences_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.preferences.id
  http_method = aws_api_gateway_method.post_preferences.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.store_preferences_lambda.invoke_arn
}

# PLAN RESOURCE
resource "aws_api_gateway_resource" "plan" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "plan"
}

resource "aws_api_gateway_method" "post_plan" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.plan.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_plan_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.plan.id
  http_method = aws_api_gateway_method.post_plan.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.plan_generator.invoke_arn
}

# CHATBOT RESOURCE
resource "aws_api_gateway_resource" "chatbot" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "chatbot"
}

resource "aws_api_gateway_method" "post_chatbot" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.chatbot.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_chatbot_lambda" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.chatbot.id
  http_method = aws_api_gateway_method.post_chatbot.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chatbot.invoke_arn
}

resource "aws_api_gateway_method" "options_chatbot" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.chatbot.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_chatbot_integration" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.chatbot.id
  http_method = aws_api_gateway_method.options_chatbot.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_chatbot_response" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.chatbot.id
  http_method = aws_api_gateway_method.options_chatbot.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_chatbot_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  resource_id = aws_api_gateway_resource.chatbot.id
  http_method = aws_api_gateway_method.options_chatbot.http_method
  status_code = aws_api_gateway_method_response.options_chatbot_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# LAMBDA PERMISSIONS
resource "aws_lambda_permission" "allow_apigateway_invoke_users" {
  statement_id  = "AllowAPIGatewayInvokeUsers"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.store_preferences_lambda.function_name
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

resource "aws_lambda_permission" "allow_apigateway_invoke_upload" {
  statement_id  = "AllowAPIGatewayInvokeUpload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_request.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/POST/upload"
}

resource "aws_lambda_permission" "allow_apigateway_invoke_generate_upload_url" {
  statement_id  = "AllowAPIGatewayInvokeGenerateUploadUrl"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_upload_url.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/POST/generate-upload-url"
}

resource "aws_lambda_permission" "allow_apigateway_invoke_plan" {
  statement_id  = "AllowAPIGatewayInvokePlan"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.plan_generator.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/POST/plan"
}

resource "aws_lambda_permission" "allow_apigateway_invoke_chatbot" {
  statement_id  = "AllowAPIGatewayInvokeChatbot"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chatbot.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/POST/chatbot"
}

# DEPLOYMENT + STAGE
resource "aws_api_gateway_deployment" "user_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id

  depends_on = [
    aws_api_gateway_method.options_chatbot,
    aws_api_gateway_integration.options_chatbot_integration,
    aws_api_gateway_method_response.options_chatbot_response,
    aws_api_gateway_integration_response.options_chatbot_integration_response,
    aws_api_gateway_method.post_users,
    aws_api_gateway_method.post_upload,
    aws_api_gateway_method.options_upload,
    aws_api_gateway_method.post_generate_upload_url,
    aws_api_gateway_method.options_generate_upload_url,
    aws_api_gateway_method.post_preferences,
    aws_api_gateway_method.post_plan,

    aws_api_gateway_integration.post_users_lambda,
    aws_api_gateway_integration.post_chatbot_lambda,
    aws_api_gateway_method.options_chatbot,
    aws_api_gateway_integration.options_chatbot_integration,
    aws_api_gateway_method_response.options_chatbot_response,
    aws_api_gateway_integration_response.options_chatbot_integration_response,
    aws_api_gateway_integration.upload_lambda,
    aws_api_gateway_integration.options_upload_integration,
    aws_api_gateway_integration.generate_upload_url_lambda,
    aws_api_gateway_integration.options_generate_upload_url_integration,
    aws_api_gateway_integration.post_preferences_lambda,
    aws_api_gateway_integration.post_plan_lambda,

    aws_api_gateway_method_response.options_upload_response,
    aws_api_gateway_integration_response.options_upload_integration_response,
    aws_api_gateway_method_response.options_generate_upload_url_response,
    aws_api_gateway_integration_response.options_generate_upload_url_integration_response,

    aws_lambda_permission.allow_apigateway_invoke_generate_upload_url,
    aws_api_gateway_authorizer.cognito_authorizer
  ]

  triggers = {
    redeployment = sha1(jsonencode({
      options_chatbot_method_id               = aws_api_gateway_method.options_chatbot.id
      options_chatbot_integration_id          = aws_api_gateway_integration.options_chatbot_integration.id
      options_chatbot_integration_response_id = aws_api_gateway_integration_response.options_chatbot_integration_response.id

      users_resource_id               = aws_api_gateway_resource.users.id
      upload_resource_id              = aws_api_gateway_resource.upload.id
      generate_upload_url_resource_id = aws_api_gateway_resource.generate_upload_url.id
      preferences_resource_id         = aws_api_gateway_resource.preferences.id
      plan_resource_id                = aws_api_gateway_resource.plan.id

      chatbot_resource_id                 = aws_api_gateway_resource.chatbot.id
      post_chatbot_method_id              = aws_api_gateway_method.post_chatbot.id
      post_chatbot_integration_id         = aws_api_gateway_integration.post_chatbot_lambda.id
      chatbot_lambda_permission_statement = aws_lambda_permission.allow_apigateway_invoke_chatbot.statement_id



      post_users_method_id               = aws_api_gateway_method.post_users.id
      post_upload_method_id              = aws_api_gateway_method.post_upload.id
      options_upload_method_id           = aws_api_gateway_method.options_upload.id
      post_generate_upload_url_method_id = aws_api_gateway_method.post_generate_upload_url.id
      options_generate_upload_url_id     = aws_api_gateway_method.options_generate_upload_url.id
      post_preferences_method_id         = aws_api_gateway_method.post_preferences.id
      post_plan_method_id                = aws_api_gateway_method.post_plan.id

      post_upload_authorization              = aws_api_gateway_method.post_upload.authorization
      post_upload_authorizer_id              = aws_api_gateway_method.post_upload.authorizer_id
      post_generate_upload_url_authorization = aws_api_gateway_method.post_generate_upload_url.authorization
      post_generate_upload_url_authorizer_id = aws_api_gateway_method.post_generate_upload_url.authorizer_id

      post_users_integration_id                        = aws_api_gateway_integration.post_users_lambda.id
      upload_integration_id                            = aws_api_gateway_integration.upload_lambda.id
      options_upload_integration_id                    = aws_api_gateway_integration.options_upload_integration.id
      options_upload_response_id                       = aws_api_gateway_method_response.options_upload_response.id
      options_upload_integration_res                   = aws_api_gateway_integration_response.options_upload_integration_response.id
      generate_upload_url_integration_id               = aws_api_gateway_integration.generate_upload_url_lambda.id
      options_generate_upload_url_integration_id       = aws_api_gateway_integration.options_generate_upload_url_integration.id
      options_generate_upload_url_response_id          = aws_api_gateway_method_response.options_generate_upload_url_response.id
      options_generate_upload_url_integration_response = aws_api_gateway_integration_response.options_generate_upload_url_integration_response.id
      post_preferences_integration_id                  = aws_api_gateway_integration.post_preferences_lambda.id
      post_plan_integration_id                         = aws_api_gateway_integration.post_plan_lambda.id
      generate_upload_url_lambda_permission_statement  = aws_lambda_permission.allow_apigateway_invoke_generate_upload_url.statement_id
    }))
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