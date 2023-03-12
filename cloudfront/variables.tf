variable "domain_name" {
   type = string
}

variable "bucket_arn" {
   type = string
}

variable "bucket_id" {
   type = string
}

variable "acm" {
   default = "arn:aws:acm:us-east-1:779524864497:certificate/b3533885-be21-440a-8880-e7ddb1f1960b"
}