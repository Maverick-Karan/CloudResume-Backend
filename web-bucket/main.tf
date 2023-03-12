terraform {
  required_version = "~> 1.3.0"
  }

  ##############################################################################
  #           S3 BUCKET FOR WEBSITE


  resource "aws_s3_bucket" "website_bucket" {
  bucket = "aws-cloud-resume-challenge-karan-test1"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  force_destroy = true

  tags = {
    Name= "CloudResume"
  }
}



####################################################################################
#            OUTPUTS

output "domain_name" {
   value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
   depends_on = [aws_s3_bucket.website_bucket]
}

output "bucket_arn" {
   value = aws_s3_bucket.website_bucket.arn
   depends_on = [aws_s3_bucket.website_bucket]
}

output "bucket_id" {
   value = aws_s3_bucket.website_bucket.id
   depends_on = [aws_s3_bucket.website_bucket]
}