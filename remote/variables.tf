variable "name_of_s3_bucket" {
   default = "cr-remotestate"
}

variable "dynamo_db_table_name" {
   default = "CR-state-locking"
}

variable "region" {
   default = "us-east-1"
}
