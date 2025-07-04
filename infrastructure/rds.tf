#subnet group para RDS private
resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "RDS subnet group"
  }
}

#instancia RDS pública
resource "aws_db_instance" "postgres" {
  identifier              = "grocery-postgres-db"
  engine                  = "postgres"
  engine_version          = "16.6"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.web_sg.id] #buscar en donde se encuentra
  db_subnet_group_name    = aws_db_subnet_group.default.name

  tags = {
    Name = "RDS PostgreSQL Adry"
  }
}
