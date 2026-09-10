# Full-Stack Deployment with Jenkins, Docker & AWS

## Project Overview

This project demonstrates an end-to-end CI/CD pipeline for deploying a full-stack application on AWS using **Terraform**, **Jenkins**, **Docker**, **Amazon ECR**, **Amazon ECS Fargate**, and an **Application Load Balancer (ALB)**.

The infrastructure is fully provisioned with Terraform, while Jenkins automates the build and deployment process from GitHub to AWS.

---

## Project Architecture

```
Developer
     │
     ▼
GitHub Repository
     │
     ▼
Jenkins Pipeline
     │
     ▼
Build Docker Images
     │
     ▼
Amazon ECR
     │
     ▼
Amazon ECS Fargate
     │
     ▼
Application Load Balancer
     │
     ▼
Users
```

---

# Technologies Used

- Terraform
- Jenkins
- Docker
- Git & GitHub
- AWS EC2
- Amazon ECS Fargate
- Amazon ECR
- Application Load Balancer (ALB)
- IAM
- Security Groups
- CloudWatch
- React
- Express.js
- Node.js

---

# AWS Region

```
us-west-2
```

---

# Project Structure

```
techpathway-2/
│
├── backend/
├── frontend/
├── terraform/
│   ├── ecs/
│   └── jenkins/
│
├── Jenkinsfile
├── README.md
└── .gitignore
```

---

# Features

- Infrastructure as Code using Terraform
- Jenkins CI/CD Pipeline
- Dockerized React Frontend
- Dockerized Express Backend
- Amazon ECR Image Repository
- Amazon ECS Fargate Deployment
- Application Load Balancer
- CloudWatch Logging
- IAM Roles and Security Groups
- End-to-End Automated Deployment

---

# Infrastructure

Terraform provisions the following AWS resources:

- VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- IAM Roles
- Jenkins EC2 Instance
- Amazon ECR Repositories
- Amazon ECS Cluster
- ECS Fargate Services
- Application Load Balancer
- Target Groups
- CloudWatch Log Groups

---

# CI/CD Pipeline

The Jenkins pipeline performs the following steps automatically:

1. Pull the latest source code from GitHub
2. Build the backend Docker image
3. Build the frontend Docker image
4. Authenticate with Amazon ECR
5. Push Docker images to Amazon ECR
6. Trigger a new deployment on Amazon ECS
7. Deploy the updated application

---

# Local Development

## Backend

Runs locally on:

```
http://localhost:8080
```

## Frontend

Runs locally on:

```
http://localhost:3000
```

The frontend communicates with the backend through the configured API endpoint.

---

# Deployment

Deploy the Jenkins infrastructure:

```bash
cd terraform/jenkins

terraform init
terraform plan
terraform apply
```

Deploy the ECS infrastructure:

```bash
cd ../ecs

terraform init
terraform plan
terraform apply
```

Push your application changes:

```bash
git add .
git commit -m "Application update"
git push origin main
```

Run the Jenkins pipeline (or configure a GitHub webhook to trigger it automatically).

---

# Testing

Verify the deployment by:

- Confirming the Jenkins pipeline completes successfully.
- Verifying Docker images exist in Amazon ECR.
- Confirming ECS services are running.
- Opening the Application Load Balancer URL.
- Confirming the frontend successfully communicates with the backend.

---

# Project Achievements

- Built a complete Infrastructure as Code solution using Terraform.
- Deployed Jenkins on AWS EC2.
- Containerized both frontend and backend applications.
- Stored Docker images in Amazon ECR.
- Deployed containers using Amazon ECS Fargate.
- Configured an Application Load Balancer for public access.
- Automated the deployment process using Jenkins CI/CD.

---

# Challenges

- ECS failed to pull container images due to an image architecture mismatch.
- Frontend Docker build failed because of dependency compatibility.
- Jenkins pipeline initially failed because Dockerfiles were not committed to GitHub.
- Terraform destroy could not remove Amazon ECR repositories because they still contained images.

---

# Solutions

- Rebuilt Docker images for the `linux/amd64` platform.
- Updated the frontend Dockerfile to resolve dependency issues.
- Committed Dockerfiles to GitHub so Jenkins could build them.
- Removed container images from Amazon ECR before running `terraform destroy`.

---

# Cleanup

Destroy the ECS infrastructure:

```bash
cd terraform/ecs
terraform destroy
```

Destroy the Jenkins infrastructure:

```bash
cd ../jenkins
terraform destroy
```
