resource "aws_db_instance" "dailyge_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  instance_class         = "db.t3.micro"
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = var.username
  password               = var.password
  parameter_group_name   = aws_db_parameter_group.daily.name
  db_subnet_group_name   = aws_db_subnet_group.dailyge_subnet_group.name
  vpc_security_group_ids = var.rds_security_group_ids
  tags                   = {
    Name = "dailyge-rds"
  }
}

resource "aws_db_parameter_group" "daily" {
  name        = "daily"
  family      = "mysql8.0"
  description = "Daily RDS parameter group."

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
}

resource "aws_db_subnet_group" "dailyge_subnet_group" {
  name        = "dailyge-subnet-group"
  description = "Subnet group for Dailyge RDS instances"
  subnet_ids  = var.rds_subnet_ids

  tags = {
    Name = "Dailyge"
  }
}
