resource "aws_iam_policy" "s3_presigner_lambda_policy" {
  name = "${var.project_name}-${var.environment}-s3-presigner-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${var.papercortex_s3_bucket_name}/*",
        Effect   = "Allow"
      },
    ],
  })
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-s3-presigner-policy"
    }
  )
}
