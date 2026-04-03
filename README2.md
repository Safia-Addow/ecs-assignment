# 🚀 ECS Deployment with Terraform, GitHub Actions & Docker

## 📌 Overview

This project demonstrates a **production-ready CI/CD pipeline** for deploying a containerized React application to AWS using modern DevOps best practices.

It covers:
- Infrastructure as Code (Terraform)
- Containerization (Docker)
- CI/CD automation (GitHub Actions)
- Secure and scalable AWS architecture (ECS Fargate)

---

## 🏗️ Architecture Diagram

```mermaid
flowchart TB

%% =========================
%% CI/CD PIPELINE
%% =========================
subgraph CICD["CI/CD Pipeline"]
    GH["GitHub Repo"]
    ACTIONS["GitHub Actions"]
    BUILD["Docker Build"]
    PUSH["Push to Amazon ECR"]
    TF["Terraform Apply"]

    GH --> ACTIONS --> BUILD --> PUSH --> TF
end

%% =========================
%% AWS REGION
%% =========================
subgraph AWS["AWS Region (eu-west-2)"]

    %% VPC
    subgraph VPC["VPC (10.0.0.0/20)"]

        %% PUBLIC
        subgraph PUBLIC["Public Subnets (Multi-AZ)"]
            IGW["Internet Gateway"]
            ALB["Application Load Balancer"]
            NAT["NAT Gateway"]
        end

        %% PRIVATE
        subgraph PRIVATE["Private Subnets (Multi-AZ)"]
            ECS["ECS Cluster (Fargate Service & Tasks)"]
        end

    end

    %% SERVICES
    ECR["Amazon ECR"]
    CW["CloudWatch Logs"]
    SSM["SSM Parameter Store"]
    ACM["AWS ACM (SSL Certificate)"]

end

%% =========================
%% TRAFFIC FLOW
%% =========================

User["User / Browser"] --> IGW --> ALB --> ECS

%% Outbound from ECS
ECS --> NAT --> ECR
ECS --> CW
ECS --> SSM

%% CI/CD Integration
PUSH --> ECR
TF --> VPC
TF --> ECS
TF --> ALB

🧠 Architecture Explanation (Interview Ready)
🌐 VPC (Virtual Private Cloud)
Custom VPC providing network isolation
CIDR block: 10.0.0.0/20
Spans multiple Availability Zones for high availability
📦 Subnets
Type	Purpose
Public Subnets	Host ALB, NAT Gateway
Private Subnets	Host ECS Fargate tasks
Ensures secure architecture

ECS tasks are not publicly accessible
⚖️ Application Load Balancer (ALB)
Internet-facing entry point
Routes traffic to ECS services
Performs health checks
Terminates HTTPS using ACM

🐳 ECS (Fargate)
Serverless container orchestration
Runs Docker containers without managing EC2
Deployed across multiple AZs

📦 Amazon ECR
Stores Docker images
Images tagged using Git commit SHA
Enables versioned deployments

🔐 AWS ACM
Manages SSL/TLS certificates
Enables secure HTTPS traffic via ALB

🔑 SSM Parameter Store
Stores sensitive data (API keys, DB credentials)
Injected securely into ECS containers

📊 CloudWatch
Logs container output
Enables monitoring and debugging

🌍 NAT Gateway
Allows ECS tasks in private subnets to:
Pull images from ECR
Access external services
Without exposing them publicly

🔄 CI/CD Pipeline Flow
Developer pushes code to main
GitHub Actions pipeline triggers:
Terraform validation & linting
Docker image build
Push image to ECR
Terraform apply
ECS service updates with new image
ALB routes traffic to healthy containers

🐳 Docker Setup

Multi-stage Docker build:

Stage 1: Build React app
Stage 2: Serve with Nginx

Benefits:

Smaller image size
Faster deployments
Production-ready setup
⚙️ Terraform Structure
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
Key Features:
Modular architecture
Remote state stored in S3
State locking via DynamoDB
🔐 Security Best Practices
ECS tasks run in private subnets
No public IPs assigned
IAM roles with least privilege
GitHub Actions uses OIDC authentication
Secrets managed via:
GitHub Secrets
AWS SSM Parameter Store
🧪 Health Check Strategy
ALB health check endpoint: /
CI/CD performs post-deploy validation using curl
Ensures only healthy containers receive traffic
🚀 Deployment
Local Development
# Build image
docker build -t ecs-assignment .

# Run container
docker run -p 8080:80 ecs-assignment
Production Deployment
# Trigger deployment
git push origin main

Pipeline handles:

Build
Push
Infrastructure update
📈 Future Improvements
Auto Scaling (ECS Service Scaling Policies)
Blue/Green deployments (AWS CodeDeploy)
WAF (Web Application Firewall)
Observability (CloudWatch + X-Ray)
Private ALB with API Gateway
✅ Project Status

✔ Fully automated CI/CD pipeline
✔ Infrastructure managed via Terraform
✔ Secure multi-AZ architecture
✔ ECS Fargate deployment
✔ HTTPS enabled via ACM

🎯 Key Learning Outcomes
Designing secure AWS networking (VPC, subnets, NAT)
Building production CI/CD pipelines
Managing infrastructure with Terraform
Deploying scalable container workloads with ECS
👤 Author

Safia Addow
DevOps Engineer Project – ECS Deployment



