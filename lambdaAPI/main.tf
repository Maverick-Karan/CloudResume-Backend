terraform {
  required_version = "~> 1.3.0"
  }

resource "aws_iam_role" "lambda_role" {
 name   = "terraform_aws_lambda_role"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Policy Attachment on the role.
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_lambda_exec" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Generates an archive from content, a file, or a directory of files.
data "archive_file" "zip_the_python_code" {
 type        = "zip"
 source_dir  = "./python/"
 output_path = "./python/lambda.zip"
}

# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "terraform_lambda_func" {
 filename                       = "./python/lambda.zip"
 function_name                  = "Lambda-Function"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "lambda.lambda_handler"
 runtime                        = "python3.8"
 depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
 timeout                        = "300"
}

# Create Function URL
resource "aws_lambda_function_url" "Func_URL" {
  function_name      = "Lambda-Function"
  authorization_type = "NONE"
  depends_on         = [aws_lambda_function.terraform_lambda_func]

  cors {
    allow_origins     = ["*"]
  }
}



# ------------------------------------------------------------------------------------
# Intergrate REST API with Lambda

resource "aws_api_gateway_rest_api" "LambdaAPI" {
  name        = "LambdaAPI"
  description = "This is API for lambda"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "APIresource" {
  rest_api_id = aws_api_gateway_rest_api.LambdaAPI.id
  parent_id   = aws_api_gateway_rest_api.LambdaAPI.root_resource_id
  path_part   = "apiresource"
}

resource "aws_api_gateway_method" "API_Method" {
  rest_api_id   = aws_api_gateway_rest_api.LambdaAPI.id
  resource_id   = aws_api_gateway_resource.APIresource.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.LambdaAPI.id
  resource_id             = aws_api_gateway_resource.APIresource.id
  http_method             = aws_api_gateway_method.API_Method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn
  depends_on              = [aws_lambda_function.terraform_lambda_func]
}


resource "aws_api_gateway_deployment" "API_Deploy" {

  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.LambdaAPI.id


  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.LambdaAPI.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "API_stage" {
  deployment_id = aws_api_gateway_deployment.API_Deploy.id
  rest_api_id   = aws_api_gateway_rest_api.LambdaAPI.id
  stage_name    = "Dev"
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = "${aws_lambda_function.terraform_lambda_func.function_name}"
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.LambdaAPI.execution_arn}/*/*"
}

