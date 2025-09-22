# 🛒 GroceryMate: Cloud Infrastructure Deployment with Terraform & AWS

This project is part of my journey as a Cloud Engineer in training, where I designed and deployed the cloud infrastructure for the GroceryMate app using Terraform and AWS services.

What started as a backend running locally became a full cloud-native deployment with EC2, RDS, S3, IAM Roles, SNS, SES, and CloudFront, all orchestrated through Infrastructure as Code.

It wasn’t always smooth but every challenge taught me how AWS works under pressure.

## 📑 Table of Contents:

1. [🚀 Project Overview](#project-overview)

2. [🖼️ Architecture Diagram](#architecture-diagram)

3. [🛠️ Infrastructure Design](#infrastructure-design)

4. [⚙️ Terraform Configuration Overview](#terraform-configuration-overview)

5. [☁️ AWS Infrastructure](#☁️AWS-infrastructure)

6. [🔐 Security Considerations](#securtity-considerations)

7. [ 📩 Notifications System (SNS + SES)](#Notifications-System-(SNS+SES))

8. [🌐 Static Assets with CloudFront](Static-Assets-with-CloudFront)

9. [🛠 Deployment Steps](#Deployment-Steps)

10. [✅ Key Learnings](#Key-Learnings)

11. [🤝 Contributing](#Contributing)

12. [🙏 Credits](Credits)

## 1. 🚀 Project Overview

GroceryMate is a backend service designed for managing users, products, and avatars.

Backend runs in a Docker container on an EC2 instance.

Data stored in Amazon RDS (PostgreSQL) within a private subnet.

User avatars stored in a private S3 bucket, accessed via IAM Role.

New product notifications are delivered via SNS → SES → Email (HTML + Images).

Product images are served efficiently via CloudFront CDN.

## 2. 🖼️ Architecture Diagram

<img width="771" height="542" alt="bonitodiagrama" src="https://github.com/user-attachments/assets/d7c416d6-f558-44c0-9d11-9fc985bbbabb" />



## 3. 🛠️ Infrastructure Design

EC2 + Docker: Containerized Flask backend running inside VPC.

RDS PostgreSQL: Managed database in private subnet.

S3 (Avatars): Private bucket for user-uploaded avatars.

S3 (Products Public): Public bucket (via CloudFront) for product images.

IAM Roles: Secure access from EC2 → S3 (no hardcoded credentials).

SNS + SES: Notification system for new products with styled HTML emails.

CloudFront CDN: Distributes product images globally with caching.

Terraform: Full infrastructure provisioning and management.

## 4. ⚙️ Terraform Configuration
 ```bash
infrastructure/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── vpc/              # Networking (VPC, subnets, IGW)
    ├── ec2/              # EC2 instance, SGs
    ├── rds/              # PostgreSQL in private subnet
    ├── s3_bucket/        # S3 (avatars + products public)
    ├── sns_ses/          # SNS Topic + SES template
    └── iam_roles_ec2/    # IAM Role for EC2 → S3
 ````

## 5. ☁️ AWS Infrastructure
| Term               | Description |
|:-------------------|:------------|
| **AWS CLI**        | Command Line Interface we used to interact with AWS services directly from the terminal (S3 uploads, SNS tests, SES emails, Lambda checks). |
| **Terraform**      | Infrastructure as Code (IaC) tool we used to provision EC2, RDS, S3, IAM roles, SNS, and Lambda automatically. |
| **EC2**            | Virtual server running the GroceryMate backend inside a Docker container. |
| **RDS (PostgreSQL)** | Managed SQL database in a private subnet, storing GroceryMate’s user and product data. |
| **S3 (Avatars)**   | Secure bucket for storing user profile images (avatars). |
| **S3 (Products Public)** | Public bucket (via CloudFront) for hosting product images used in SES emails. |
| **IAM Roles**      | Secure access control: EC2 and Lambda assume roles to interact with S3 and SNS without hardcoded credentials. |
| **SNS**            | Simple Notification Service — used to broadcast new product events. |
| **Lambda**         | Function triggered by SNS to format and forward notifications. |
| **SES**            | Simple Email Service — sends branded HTML emails with product details and images. |
| **CloudFront**     | CDN (Content Delivery Network) in front of S3 to serve product images reliably in SES emails. |
| **VPC & Subnets**  | Isolated networking with public/private subnets, securing database and backend. |
| **Security Groups**| Virtual firewalls controlling inbound/outbound traffic for EC2, RDS, and other resources. |

## 6. 🔐 Security

RDS in private subnet (not exposed to internet).

S3 avatars bucket private, accessible only via IAM Role.

CloudFront distribution for controlled, cached access to public product images.

No hardcoded AWS credentials, all managed by IAM Roles and profiles.

## 7.  📩 Email Notifications with SES + CloudFront
As part of the project, I integrated **Amazon SNS + Lambda + SES** to deliver **email notifications** when new products are available.  
The final setup allows sending **HTML-based emails** with images and call-to-action buttons.  

- Product data (name, SKU, price) is published via **SNS**.

- A **Lambda function** reformats and sends the data using **SES templates**.  
- Product images are hosted in **S3** and served securely via **CloudFront** for fast global delivery.  
- The final email includes:
  - Product name, SKU, and price  
  - Product image  
  - Buttons to *View Product* or *Manage Preferences*  


---



### 📸 Example Email

<img width="737" height="666" alt="imagenaguacate" src="https://github.com/user-attachments/assets/a69ab7e7-3bcb-4145-ba8d-653f7380149e" />



## 8. 🌐 Static Assets with CloudFront

Product images are uploaded to a public S3 bucket.

CloudFront is used to:

Serve images over HTTPS

Enable caching and faster global delivery

Solve email client image-loading issues

## 9. 🛠 Deployment Steps

1. Provisioned VPC with public/private subnets using Terraform.
2. Deployed EC2 with security groups and IAM Role.
3. Created RDS PostgreSQL in private subnet.
4. Uploaded default avatar to S3 bucket.
5. Built Docker image locally and transferred it via `scp`.
6. Ran Flask container with S3 and DB environment variables.
7. Verified full stack functionality from EC2.


## 10. ✅ Key Learnings


1. **Terraform = Single Source of Truth**  
   - Every change in infrastructure is versioned and applied consistently.  
   - I learned that even small syntax or structural errors can break an entire deployment.  

2. **AWS CLI as a superpower**  
   - The **CLI** is not just a “helper,” it’s the fastest way to diagnose live issues (SNS, SES, S3, Lambda, etc.).  
   - Through the CLI I confirmed identities, published messages, and inspected logs.  

3. **IAM Roles vs Keys**  
   - It’s far more secure to give permissions to EC2 or Lambda via **temporary roles** instead of exposing `AWS_ACCESS_KEY` and `AWS_SECRET_KEY`.  
   - This saved me from exposing sensitive credentials.  

4. **Logging and real debugging**  
   - **CloudWatch Logs** became my ally: reviewing Lambda errors, analyzing permission failures, and understanding why an event wasn’t firing.  
   - I also learned to track containers on **EC2 with Docker** (`docker logs`).  

5. **S3 and the magic of CloudFront**  
   - At first, product images wouldn’t display.  
   - The solution was to master **headers, cache, and Content-Type**, and finally serve them through **CloudFront**, ensuring SES emails reliably showed images.  

6. **SES and HTML emails**  
   - Plain JSON messages from SNS weren’t enough:  
     - With **SES templates** I built professional emails with HTML, buttons, and embedded product images.  
   - I learned to prepare compressed, optimized images so they render correctly in emails.  

7. **Resilience in debugging**  
   - Most importantly: every error (credentials, ACLs, time sync, SES spam) forced me to dig deeper into AWS.  
   - I confirmed that in Cloud, the essentials are **patience + logs + small step-by-step testing**.  



---
##

## 11. 🤝 Contributing
- We welcome contributions! Follow these steps:
  - Fork the repository 
  - Create a feature branch: git checkout -b feature/your-feature 
  - Implement changes & commit 
  - Push & create a Pull Request (PR)



## 12. 🙏 Credits

Special thanks to my mentors and instructors at **Masterschool**, and to **Alejandro Román Ibáñez** for the original GroceryMate repository that inspired this deployment..









