module "s3_presigner_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "${var.project_name}-${var.environment}-s3-presigner"
  description   = "Generates presigned URLs for the ${var.papercortex_s3_bucket_name} S3 bucket."
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
  environment_variables = {
    BUCKET_NAME = var.papercortex_s3_bucket_name
  }
  source_path        = "../dist/"
  logging_log_group  = "/aws/lambda/${var.project_name}-${var.environment}/s3_presigner"
  publish            = true
  attach_policies    = true
  number_of_policies = 1
  policies = [
    aws_iam_policy.s3_presigner_lambda_policy.arn
  ]
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.apigateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-s3-presigner-lambda"
    }
  )
}
