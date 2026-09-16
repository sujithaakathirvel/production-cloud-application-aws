variable "subnet_ids" {}
variable "rds_sg_id" {}
variable "db_password" {
  sensitive = true
}
