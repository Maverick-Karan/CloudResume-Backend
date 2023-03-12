locals {
  json_data  = file("./dynamoDB/data.json")
  tf_data    = jsondecode(local.json_data)
}