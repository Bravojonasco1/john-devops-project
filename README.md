# 🚀 End-to-End DevOps Deployment Project

## 📖 Project Overview

This project demonstrates a complete modern DevOps workflow by deploying three different applications using Infrastructure as Code, Docker, Docker Compose, Nginx Reverse Proxy, Jenkins CI/CD, Docker Hub, and AWS EC2.

The project automates application build, containerization, image publishing, and deployment to AWS.

---

# 🏗 Architecture

```
                GitHub
                   │
                   ▼
             Jenkins Pipeline
                   │
      ┌────────────┴────────────┐
      ▼                         ▼
 Maven Build              Docker Build
      │                         │
      └────────────┬────────────┘
                   ▼
              Docker Hub
                   │
                   ▼
             AWS EC2 Instance
                   │
            Docker Compose
                   │
                   ▼
          Nginx Reverse Proxy
        ┌────────┼────────┐
        ▼        ▼        ▼
 Portfolio     Flask     Java
```

---

# 📦 Applications

## Portfolio Application

- Static HTML/CSS website
- Served using Nginx
- Dockerized

---

## Flask Application

- Python Flask
- Dockerized
- Reverse proxied through Nginx

---

## Java Web Application

- Java
- Maven
- Tomcat
- Dockerized

---

# ⚙ Technologies Used

- AWS EC2
- Terraform
- Docker
- Docker Compose
- Jenkins
- Git
- GitHub
- Docker Hub
- Nginx
- Python Flask
- Java
- Maven
- Linux (Amazon Linux 2023)

---

# 🚀 CI/CD Pipeline

The Jenkins pipeline performs the following stages automatically:

- Checkout Source Code
- Verify Environment
- Build Java WAR
- Build Portfolio Docker Image
- Build Flask Docker Image
- Build Java Docker Image
- Docker Hub Login
- Push Images to Docker Hub
- Deploy Using Docker Compose
- Health Check
- Cleanup Workspace

---

# 📂 Project Structure

```
john-devops-project/
│
├── terraform/
│
├── portfolio-app/
│
├── flask-app/
│
├── java-web-app/
│
├── nginx/
│
├── scripts/
│
├── Jenkinsfile
│
├── docker-compose.yml
│
└── README.md
```

---

# 🌐 Reverse Proxy Routes

| URL | Application |
|------|-------------|
| / | Portfolio |
| /api/ | Flask |
| /java/ | Java |

---

# 🐳 Docker Images

- bravojonasco/portfolio-app
- bravojonasco/flask-app
- bravojonasco/java-web-app
- bravojonasco/nginx-proxy

---

# ☁ Infrastructure

Provisioned using Terraform.

Includes:

- VPC
- Public Subnets
- Internet Gateway
- Route Tables
- Security Groups
- EC2 Instance

---

# 📸 Screenshots

This repository includes screenshots of:

- Terraform deployment
- Jenkins Pipeline
- Docker Hub repositories
- Running Docker containers
- Portfolio Application
- Flask Application
- Java Application

---

# 🎯 Features

- Infrastructure as Code
- Automated CI/CD
- Dockerized Applications
- Reverse Proxy
- Multi-container Deployment
- Docker Hub Integration
- AWS Deployment

---

# 🔮 Future Improvements

- HTTPS with Let's Encrypt
- Prometheus Monitoring
- Grafana Dashboards
- Kubernetes Deployment (Amazon EKS)
- Ansible Automation
- Centralized Logging (Loki)

---

# 👨‍💻 Author

**John Eziorobo**

DevOps Engineer

GitHub:
https://github.com/Bravojonasco1
