# 🛠 Infrastructure Setup with Terraform

This folder contains the infrastructure-as-code (IaC) setup for the project using **Terraform** on AWS.

## 📁 What's Included

- ✅ EC2 Instance
- ✅ Security Group (SSH + HTTP)
- ✅ RDS PostgreSQL instance

## 🚀 How to Deploy

1. Make sure you are authenticated via AWS SSO or `aws configure`.
2. Move into the folder:

   ```bash
   cd infrastructure/
Initialize Terraform:

3. Initialize Terraform:

terraform init

4. Apply the infrastructure (with your own password):

terraform apply -var="db_password=YOUR_SECURE_PASSWORD"

Or create a terraform.tfvars file with:

db_password = "YOUR_SECURE_PASSWORD"

🧾 Outputs
EC2 Public IP

RDS PostgreSQL Endpoint

You can view them with:

terraform output

🛑🔒 Important Notes
Do not commit .pem files or terraform.tfvars.

These are ignored via .gitignore.

🛡 .gitignore Notes
The following files are ignored for security:

Copiar
Editar
*.pem
terraform.tfvars
terraform.tfstate
.terraform/

❌ Never commit .pem files or terraform.tfvars with passwords.

