resource "aws_sagemaker_model" "plan_generator_model" {
  name               = "fitness-plan-generator-model"
  execution_role_arn = var.sagemaker_execution_role_arn

  primary_container {
    image          = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-xgboost:1.5-1"
    model_data_url = var.model_artifact_s3_uri
  }
}


resource "aws_sagemaker_endpoint_configuration" "plan_generator_config" {
  name = "fitness-plan-generator-config"

  production_variants {
    variant_name           = "AllTraffic"
    model_name             = aws_sagemaker_model.plan_generator_model.name
    instance_type          = "ml.t2.medium"
    initial_instance_count = 1
  }
}

resource "aws_sagemaker_endpoint" "plan_generator_endpoint" {
  name                 = "fitness-plan-generator-endpoint-v2"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.plan_generator_config.name
}