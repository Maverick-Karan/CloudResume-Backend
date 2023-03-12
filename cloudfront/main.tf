terraform {
  required_version = "~> 1.3.0"
  }

locals {
  s3_origin_id = "myS3Origin"
}


#################################################
# CLOUDFRONT

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Terraform"
  default_root_object = "index.html"

  

 aliases = ["karanchugh.ca"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    #forwarded_values {
    #  query_string = false

    #   cookies {
    #       forward = "none"
    #     }    
    #}

    viewer_protocol_policy = "redirect-to-https"
    #min_ttl                = 0
    #default_ttl            = 3600
    #max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      #restriction_type = "whitelist"
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    #cloudfront_default_certificate = false
    acm_certificate_arn = var.acm
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}


##################################################################
#CLOUDFRONT ORIGIN ACCESS CONTROL

resource "aws_cloudfront_origin_access_control" "OAC" {
  name                              = "S3-access-control"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


##########################################################
# ATTACH CLOUDFRONT POLICY TO S3


resource "aws_s3_bucket_policy" "S3-policy" {
  depends_on = [data.aws_iam_policy_document.s3_policy]
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}


data "aws_iam_policy_document" "s3_policy" {
  depends_on = [aws_cloudfront_distribution.s3_distribution]
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${var.bucket_arn}/*"]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "AWS:SourceArn"
      values   = ["${aws_cloudfront_distribution.s3_distribution.arn}"]
    }
  }
}

#################################################################################
# OUPUTS

output "cloudfront_dns" {
   depends_on = [aws_cloudfront_distribution.s3_distribution]
   value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_zone_id" {
   depends_on = [aws_cloudfront_distribution.s3_distribution]
   value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}