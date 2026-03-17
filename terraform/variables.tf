variable "aws_region" {
  default = "us-east-1" # or your actual region
}

variable "sagemaker_execution_role_arn" {
  type = string
}

variable "model_artifact_s3_uri" {
  type = string
}
