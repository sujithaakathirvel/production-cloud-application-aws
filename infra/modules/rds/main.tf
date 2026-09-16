resource "aws_db_subnet_group" "db_subnet" {
  name = "cloud-db-subnet"

  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "db" {
  identifier        = "cloud-db"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "postgres"
  password = var.db_password

  db_name = "tasksdb"

  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.rds_sg_id]

  skip_final_snapshot = true
  publicly_accessible = false
}
