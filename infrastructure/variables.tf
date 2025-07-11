variable "instance_name" {
  description = "Name of EC2 instance"
  type        = string
  default     = "terraform-instance"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of existing AWS key pair"
  type        = string
  default     = "grocerykey"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "profile" {
  description = "AWS CLI named profile (if used)"
  type        = string
  default     = "administradoracces" 
}

variable "ami" {
  description = "Amazon Machine Image ID"
  type        = string
  default     = "ami-02b7d5b1e55a7b5f1"
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  default     = "grocerydb"
}

variable "db_username" {
  description = "Username for the PostgreSQL DB"
  default     = "adryadmin"
}

variable "db_password" {
  description = "Password for the PostgreSQL DB"
  sensitive   = true
}