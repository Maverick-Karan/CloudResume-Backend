variable "name_of_s3_bucket" {
   default = "cr-frontend-remotestate"
}

variable "dynamo_db_table_name" {
   default = "CR-Frontend-state-locking"
}

variable "region" {
   default = "us-east-1"
}
