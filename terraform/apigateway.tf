resource "aws_cloudwatch_log_group" "apigateway" {
  name = "/aws/apigateway/${var.project_name}-${var.environment}-api-gateway"
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-api-gateway-logs"
  })
}

module "apigateway" {
  source        = "terraform-aws-modules/apigateway-v2/aws"
  name          = "${var.project_name}-${var.environment}-papercortex-api-gateway"
  description   = "API Gateway for the ${var.project_name} application in ${var.environment} environment."
  protocol_type = "HTTP"
  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }
  create_api_domain_name                   = false
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.apigateway.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"
  integrations = {
    "POST /presigned-s3-url" = {
      lambda_arn             = module.s3_presigner_lambda.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }
  }
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-api-gateway"
  })
}
