data "aws_iam_policy_document" "allow_cloudfront_access" {
  version = "2008-10-17"
  
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    
    actions = ["s3:GetObject"]
    
    resources = ["${var.bucket_arn}/*"]
    
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      // values   = ["arn:aws:cloudfront::637423419750:distribution/${aws_cloudfront_distribution.shomotsu_development_distribution.id}"]
      values = ["arn:aws:cloudfront::637423419750:distribution/E277EIQIIC08C8"]
    }
  }
}