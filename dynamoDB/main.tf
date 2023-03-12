terraform {
  required_version = "~> 1.3.0"
  }


resource "aws_dynamodb_table" "visitor_count" {
  name = "visitor-counter"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
    
  tags = {
    Name    = "CloudResume"
  }
}


resource "aws_dynamodb_table_item" "add_item" {
  for_each = local.tf_data
  table_name = aws_dynamodb_table.visitor_count.name
  hash_key   = aws_dynamodb_table.visitor_count.hash_key
  item = jsonencode(each.value)
}