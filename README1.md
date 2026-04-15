# 🚀 AWS ECS Deployment with Terraform (DevOps Project)

## 📌 Overview

This project demonstrates the deployment of a containerised application using **Amazon ECS (Elastic Container Service - Fargate)** with **Terraform** for Infrastructure as Code (IaC). It provisions and configures core AWS services including **Amazon ECR**, **Amazon S3**, networking, and ECS resources.

The solution showcases modern DevOps practices such as automated infrastructure provisioning, container orchestration, and cloud-native deployment using a scalable, serverless architecture.

---

## 🏗️ Architecture

The system consists of:

* **Amazon ECS (Fargate)** – runs containerised applications without managing servers
* **Amazon ECR** – stores and manages Docker container images
* **Amazon S3** – stores Terraform remote state securely
* **IAM Roles** – manage secure access between AWS services
* **VPC & Networking** – enables secure communication between resources

---

## 📊 Architecture Diagram

![ECS Architecture](docs/ecs-architecture.png)

---

## ⚙️ Technologies Used

* **AWS ECS (Fargate)**
* **AWS ECR**
* **AWS S3**
* **Terraform**
* **Docker**
* **Git & GitHub**

---

## 🚀 Features

* Infrastructure as Code using Terraform
* Bootstrap layer for foundational resources (S3 & ECR)
* Automated provisioning of AWS infrastructure
* Container deployment using ECS Fargate
* Remote Terraform state management
* Scalable and serverless container architecture
* Secure IAM-based access control

---

## 📂 Project Structure

```bash
.
├── bootstrap/
│   └── main.tf        # Creates S3 bucket (state) & ECR repository
├── ecs/
│   ├── main.tf        # ECS infrastructure and services
│   ├── variables.tf
│   └── outputs.tf
├── app/
│   └── Dockerfile     # Application container definition
├── docs/
│   └── ecs-architecture.png
└── README.md
```

---

## 🔄 Deployment Steps

### 🔹 Prerequisites

* AWS CLI installed and configured
* Terraform installed
* Docker installed
* AWS account with appropriate IAM permissions

---

### 🔹 1. Bootstrap infrastructure (S3 + ECR)

This step provisions foundational resources required for Terraform state and container storage.

```bash
cd bootstrap
terraform init
terraform apply
```

---

### 🔹 2. Deploy ECS infrastructure

```bash
cd ../ecs
terraform init
terraform apply
```

---

### 🔹 3. Build and push Docker image

```bash
docker build -t ecs-app .
docker tag ecs-app:latest <your-ecr-url>:latest
docker push <your-ecr-url>:latest
```

---

## 🧠 DevOps Concepts Demonstrated

* Infrastructure as Code (Terraform)
* Containerisation using Docker
* Cloud resource provisioning (AWS)
* Remote state management using S3
* Separation of bootstrap and application infrastructure
* Secure IAM role configuration
* CI/CD-ready architecture

---

## 🔐 Security Considerations

* IAM roles used instead of hardcoded credentials
* S3 bucket encryption enabled for Terraform state
* ECR image scanning enabled on push
* Principle of least privilege applied across resources

---

## ❗ Challenges & Solutions

**Issue:** Terraform backend requires S3 before initialisation
**Solution:** Implemented a separate **bootstrap layer** to provision S3 and ECR before deploying main infrastructure

**Issue:** ECS container failed to start
**Solution:** Fixed IAM execution role and ensured correct ECR image URI was used

**Issue:** Networking issues preventing container access
**Solution:** Configured correct subnets, security groups, and outbound internet access

**Issue:** Docker image not pulling from ECR
**Solution:** Verified authentication using `aws ecr get-login-password` and ensured correct repository permissions

**Issue:** Git conflicts during development
**Solution:** Resolved conflicts using rebase workflow and maintained clean commit history

---

## 📈 Future Improvements

* Implement CI/CD pipeline using GitHub Actions
* Add Application Load Balancer for traffic routing
* Enable auto-scaling for ECS services
* Integrate CloudWatch logging and monitoring
* Refactor Terraform into reusable modules

---

## 👨‍💻 Author

Safia Addow
DevOps Engineer

---
