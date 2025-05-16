resource "aws_db_subnet_group" "private" {
  name       = "private-rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "Private RDS Subnet Group"
  }
}

resource "aws_db_instance" "postgres_private" {
  identifier              = "grocery-rds-private"
  engine                  = "postgres"
  engine_version          = "15.13"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.web_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.private.name

  tags = {
    Name = "Private RDS PostgreSQL"
  }
}
