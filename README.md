# Kubernetes Message Board

## Summary

- This project implements a full-stack web application (an online message board) where users can create, read, and delete messages, and deploys it to a custom, highly available Kubernetes cluster on AWS using Elastic Kubernetes Service (***___without___*** the use of premade tools such as eksctl).  
  
- The project consists of 4 parts: 
  - Web Application
  - Cloud Infrastructure
  - Kubernetes Helm Chart
  - CI/CD Pipeline

- Technologies used: Kubernetes, Helm, AWS, Terraform, Docker, Github Actions, JavaScript (ReactJS), Python (Flask), MySQL  

- AWS services used: EKS, ECR, VPC, Subnets, DynamoDB, ALB, RDS, EC2, S3, Route53, IGW, NATGW, SG, Route Tables

## Architecture

- This section details the underlying architecture of the project in more detail.

#### Architecture Diagram

[![Kubernetes Message Board Architecture](KMB_Architecture.png)]

#### Notes

- The web application can be broken down into 3 tiers
  - Frontend tier runs in "frontend pods" in the EKS cluster. Consists of a React application that presents the message board UI to the user. Allows the user to read, write and delete messages.
  - API tier runs in "api pods" in the EKS cluster. Consists of a Flask application that recieves/sends requests to/from the frontend and to/from the database tier.
  - Database tier which runs outside of the EKS cluster. A multi-AZ MySQL RDS database that contains user messages.
 
- Ingress rules use the frontend service as the default backend.

- The Helm Chart consists of:
  - Deployments for both the frontend and API tiers. Each deployment creates 2 pods per worker node, meaning that each worker node runs 2 frontend pods and 2 API pods.
  - Services for both the frontend and API pods.
  - MySQL ConfigMap and Secrets, these are used as environment variables for the API pods in order for them to authenticate to the database properly to read / write messages.

- Github Actions CI/CD pipeline contains Secrets / Variables that are injected into the Helm Chart's MySQL ConfigMap / Secret, as part of the Job that installs the Helm Chart into the EKS cluster.

## Future Enhancements / Todo

- Bastion host is a potential single point of failure, as it's only provisioned in one subnet in one availability zone and is needed to configure the MySQL database.
- Docker images are tagged as "latest", this makes it hard to roll back to previous images if needed.
- Helm Chart versions are not being incremented on subsequent code pushes.
