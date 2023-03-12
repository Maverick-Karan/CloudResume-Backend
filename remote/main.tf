terraform {
  required_version = "~> 1.3.0"
  }

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.name_of_s3_bucket

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

  tags = {
    Name= "S3Backend"
  }
}



resource "aws_dynamodb_table" "db_lock_state" {
  name = var.dynamo_db_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.dynamo_db_table_name
  }
}