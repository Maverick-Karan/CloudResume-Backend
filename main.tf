
terraform {

  required_version = "~> 1.3.0"

  backend "s3" {
    bucket         = "cr-remotestate"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "CR-state-locking"
    encrypt        = true
  }
}


module "dynamo-db" {
   source = "./dynamoDB"
}

module "website-bucket" {
   source = "./web-bucket"
   depends_on = [module.dynamo-db]
}

module "lambda-API" {
   source = "./lambdaAPI"
   depends_on = [module.website-bucket]
}

module "cloud-front" {
   source = "./cloudfront"
   domain_name = module.website-bucket.domain_name
   bucket_arn  = module.website-bucket.bucket_arn
   bucket_id   = module.website-bucket.bucket_id
   depends_on = [module.lambda-API]
}

module "route53" {
   source = "./route53"
   cloudfront_dns      = module.cloud-front.cloudfront_dns
   cloudfront_zone_id = module.cloud-front.cloudfront_zone_id
   depends_on = [module.cloud-front]
}