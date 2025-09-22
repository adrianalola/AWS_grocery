
#VPC por defecto
data "aws_vpc" "default" {
  default = true
}

#subnets 
data "aws_subnets" "private" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

#security Group para EC2 y RDS (SSH y HTTP)
resource "aws_security_group" "web_sg" {
  name        = "web_sg_adry"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["37.201.153.157/32"] #IP para SSH
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #HTTP open
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #no restricciones
  }
}

#regla adicional para permitir PostgreSQL (5432) entre recursos del mismo Security Group
resource "aws_security_group_rule" "allow_postgres_from_same_sg" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.web_sg.id
  description              = "Allow PostgreSQL access from EC2s in same SG"
}

#EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = var.instance_name
  }

  depends_on = [aws_security_group.web_sg]
}

######## SNS Topic ########
module "sns" {
  source       = "./modules/sns"
  project_name = var.project_name
}

######## Lambda Publisher (publica en SNS) ########
module "lambda_publisher" {
  source             = "./modules/lambda_publisher"
  project_name       = var.project_name
  sns_topic_arn      = module.sns.topic_arn
  lambda_source_file = "${path.root}/../lambda/new_product_notifier/app.py"
}
