# 🚀 ECS Deployment with Terraform, GitHub Actions & Docker

## 📌 Overview

This project demonstrates a complete CI/CD pipeline for deploying a React application to AWS using:

* Docker
* Amazon ECR
* Amazon ECS (Fargate)
* Application Load Balancer (ALB)
* Terraform (Infrastructure as Code)
* GitHub Actions (CI/CD)

---

## 🏗️ Architecture Diagram
```mermaid
flowchart TB

%% CI/CD
subgraph CICD["CI/CD Pipeline"]
    GH["GitHub (Code Push)"]
    CI["GitHub Actions"]
    BUILD["Docker Build & Push"]
    TF["Terraform"]
    
    GH --> CI --> BUILD --> TF
end

%% AWS
subgraph AWS["AWS (eu-west-2)"]

    subgraph VPC["VPC (10.0.0.0/20)"]

        subgraph PUB["Public Subnets (2 AZs)"]
            IGW["Internet Gateway"]
            ALB["Application Load Balancer"]
            NAT["NAT Gateway"]
        end

        subgraph PRIV["Private Subnets (2 AZs)"]
            ECS["ECS Cluster (Fargate Service)"]
        end

    end

    ECR["Amazon ECR"]
    CW["CloudWatch Logs"]
    SSM["SSM Parameter Store"]
    ACM["ACM SSL Certificate"]

end

%% FLOW
User --> IGW --> ALB --> ECS

ECS --> NAT --> ECR
ECS --> CW
ECS --> SSM

TF --> VPC
TF --> ECS
TF --> ALB
TF --> ECR
## 🧩 Architecture Components

### 🌐 VPC

* Custom Virtual Private Cloud
* Provides network isolation

### 📦 Subnets

* **Public Subnet** → Hosts ALB
* **Private Subnet** → Hosts ECS tasks

### ⚖️ Application Load Balancer (ALB)

* Routes incoming HTTP/HTTPS traffic
* Performs health checks

### 🐳 ECS (Fargate)

* Runs containerized React application
* Serverless container orchestration

### 📦 ECR (Elastic Container Registry)

* Stores Docker images
* Images tagged with Git commit SHA

### 🔐 ACM (AWS Certificate Manager)

* Provides SSL/TLS certificates
* Enables HTTPS on ALB

### 🏗️ Terraform

* Provisions all infrastructure
* Manages state using S3 + DynamoDB locking

### ⚙️ GitHub Actions

* Automates build, push, and deployment

---

## 🔄 CI/CD Pipeline Flow

1. Code pushed to `main` branch
2. GitHub Actions pipeline runs:

   * Lint & validate Terraform
   * Build Docker image
   * Push image to ECR
   * Run Terraform plan & apply
3. ECS service updates with new image
4. ALB routes traffic to new healthy tasks

---

## 🐳 Docker Setup

Multi-stage build:

* Stage 1: Build React app
* Stage 2: Serve with Nginx

---

## ⚙️ Terraform Structure

```
infra/
 ├── main.tf
 ├── variables.tf
 ├── backend.tf
 └── modules/
     ├── vpc/
     ├── alb/
     ├── ecs/
     ├── ecr/
     ├── acm/
```

---

## 🔐 Security

* IAM Role with OIDC for GitHub Actions
* Secrets stored in GitHub Secrets
* Private subnets for ECS tasks

---

## 🧪 Health Check

* ALB health check path: `/`
* CI/CD verifies application via curl

---

## 🚀 Deployment Steps

```bash
# Build locally
docker build -t ecs-assignment .

# Run locally
docker run -p 8080:80 ecs-assignment

# Deploy via GitHub Actions

# Push to main branch
```

---

## 📈 Future Improvements

* Add autoscaling policies
* Add monitoring (CloudWatch)
* Improve security groups
* Add blue/green deployments

---

## ✅ Status

✔ Fully working CI/CD pipeline
✔ Infrastructure automated with Terraform
✔ Application deployed on ECS with ALB
✔ HTTPS enabled via ACM

---

## 👤 Author
Safia Addow
DevOps Project - ECS Assignment
