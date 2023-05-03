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
   default = "arn:aws:acm:us-east-1:664967790151:certificate/8053691a-8b4f-4d37-9b69-6eeb2d0f264e"
}