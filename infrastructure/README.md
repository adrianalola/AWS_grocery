🛠 Infrastructure Setup with Terraform
This folder contains the infrastructure-as-code (IaC) setup for the project using Terraform on AWS. It includes everything needed to launch a backend-ready environment with compute and database resources.

📁 What's Included
✅ EC2 Instance (Amazon Linux 2) with key pair access
✅ Security Group allowing SSH (port 22) and HTTP (port 80)
✅ RDS PostgreSQL instance (version configurable)
✅ Modular files for better organization
✅ .gitignore to protect sensitive files
🚀 How to Deploy
🔐 Authenticate with AWS
Using SSO:

aws sso login --profile YOUR_PROFILE_NAME
Or with credentials:

aws configure
📦 Move into the infrastructure folder:
cd infrastructure/
🧱 Initialize Terraform:
terraform init
🚀 Apply the infrastructure:
With password inline:

terraform apply -var="db_password=YOUR_SECURE_PASSWORD"
Or create a terraform.tfvars file with:

db_password = "YOUR_SECURE_PASSWORD"
Then just run:

terraform apply
📤 View outputs (EC2 IP, RDS endpoint):
terraform output
🔧 Optional: Using the Makefile
You can also use the included Makefile to simplify commands:

make init
make apply DB_PASSWORD=YOUR_SECURE_PASSWORD
make outputs
make destroy DB_PASSWORD=YOUR_SECURE_PASSWORD
🛡 .gitignore Notes
The following files are ignored for security:

*.pem
terraform.tfvars
.terraform/
terraform.tfstate
terraform.tfstate.backup

❌ Never commit .pem files or terraform.tfvars with passwords.

