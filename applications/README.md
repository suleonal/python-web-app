# Python Web App
## _This document contains all devops processes of a new python-web application._

## Installation Guide
- Docker
- Terraform 
- Kubectl
- Helm
- Kind
- Jenkins
- PostgreSQL
- Redis
- ArgoCD

## Overview
This document provides a complete end-to-end setup for a Python web application deployed on Kubernetes. The setup includes containerization, CI/CD pipelines, infrastructure provisioning, and integration with PostgreSQL and Redis. All resources are managed with Git, ensuring reproducibility and maintainability.

## Application Description
Python Web Application
This is a simple Python web application designed to demonstrate the following:

Database Interaction: Users can persist their data using PostgreSQL.
Caching Mechanism: Redis is used to cache frequent data queries for performance improvement.
Deployment: The application is containerized and deployed using Helm charts, ensuring scalability and maintainability.
CI/CD Pipeline: Build and deployment are managed using Jenkins pipelines integrated with Kaniko for Docker-less image building.

## Setup
#### 1. Docker
Enables containerization for deploying the Python application.
```sh
#!/bin/bash

sudo apt-get install -y ca-certificates curl software-properties-common
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker and required components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Docker installation completed. Checking version..."
docker --version

sudo usermod -aG docker $USER
newgrp docker
```
#### 2. Terraform
 Provides Infrastructure as Code (IaC) capabilities to define and provision infrastructure.
```sh
#!/bin/bash

echo "Installing required dependencies..."
sudo apt-get install -y software-properties-common gnupg

echo "Adding HashiCorp GPG key..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "Adding HashiCorp repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update -y

echo "Installing Terraform..."
sudo apt-get install -y terraform

echo "Installation completed. Terraform version:"
terraform -v
```
#### 3. Kubectl
CLI tool for managing Kubernetes clusters.
```sh
!/bin/bash

echo "Installing prerequisites..."
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "Adding Kubernetes GPG key..."
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "Adding Kubernetes apt repository..."
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package lists after adding Kubernetes repo..."
sudo apt-get update

echo "Installing kubectl..."
sudo apt-get install -y kubectl

echo "Verifying kubectl installation..."
kubectl version --client
```
#### 4. Helm
Kubernetes package manager for deploying and managing applications.
```sh
#!/bin/bash

echo "Downloading Helm GPG key..."
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

echo "Installing APT transport-https..."
sudo apt-get install apt-transport-https --yes

echo "Adding Helm repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

echo "Updating package lists..."
sudo apt-get update

echo "Installing Helm..."
sudo apt-get install helm --yes

echo "Checking Helm version..."
helm version
```
# Installation

### Create Kind Cluster with Terraform
Kind (Kubernetes IN Docker) is a tool for running local Kubernetes clusters using Docker container "nodes". It is commonly used for testing Kubernetes features and performing local development or CI tasks. Using Terraform, you can automate the creation of a Kind cluster, ensuring consistency and repeatability.

Initialize Terraform Use the terraform init command to download the required provider plugins, including the Kind provider.
```sh
terraform init
```
Apply the Terraform Configuration Run terraform apply to create the Kind cluster based on the provided configuration.
```sh
terraform apply
```
Verify the Cluster After the cluster is created, use kubectl to confirm that it is running correctly:
```sh
kubectl cluster-info --context cluster1-kind
kubectl get nodes
```
Here is a detailed Terraform configuration for creating a Kind cluster:
```sh
terraform {
  required_version = ">= 1.10.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.7.0"
    }
  }
}

resource "kind_cluster" "cluster" {
  name            = local.cluster_name
  node_image      = "kindest/node:v${local.cluster_version}"
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    # Control plane node configuration
    node {
      role = "control-plane"

      kubeadm_config_patches = [
        <<EOT
kind: InitConfiguration
nodeRegistration:
  kubeletExtraArgs:
    node-labels: "ingress-ready=true"
EOT
      ]
      
      extra_port_mappings {
        container_port = 30001
        host_port      = 30001
      }
      extra_port_mappings {
        container_port = 30002
        host_port      = 30002
      }
      extra_port_mappings {
        container_port = 30003
        host_port      = 30003
      }
      extra_port_mappings {
        container_port = 30004
        host_port      = 30004
      }
      extra_port_mappings {
        container_port = 30005
        host_port      = 30005
      }
      extra_port_mappings {
        container_port = 30006
        host_port      = 30006
      }
      extra_port_mappings {
        container_port = 30007
        host_port      = 30007
      }
      extra_port_mappings {
        container_port = 30008
        host_port      = 30008
      }
      extra_port_mappings {
        container_port = 30009
        host_port      = 30009
      }
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        protocol       = "TCP"
        listen_address = "0.0.0.0"
      }
    }

    # Worker node configuration
    node {
      role = "worker"

      kubeadm_config_patches = [
        <<EOT
kind: JoinConfiguration
nodeRegistration:
  kubeletExtraArgs:
    node-labels: "ingress-ready=true"
EOT
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 8080
        listen_address = "0.0.0.0"
      }
    }
  }
}

locals {
  cluster_name    = "cluster1"
  cluster_version = "1.31.0"
}

output "cluster_endpoint" {
  value = kind_cluster.cluster.endpoint
}
```
NOTE:
The extra_port_mappings block is used to map specific NodePort services from the Kind cluster to the host machine. This allows you to access services running inside the Kind cluster on specific ports from your local machine.

In Kubernetes clusters, NodePort is one of the service types used to expose applications running within the cluster to the outside world. When you use NodePort, Kubernetes opens a specific port on all cluster nodes, allowing external traffic to access the service. By using extra_port_mappings, Kind replicates this behavior in a local environment, making NodePort services accessible from your local machine.

### Python Application Installation
The following Dockerfile is designed to create a secure and efficient container for the Python application. It ensures all dependencies are installed, sets up a non-root user for security, and launches the application (app.py) when the container starts.
```sh
docker build -t python-app .
docker tag python-app suleonal/python-web-app:1.0.0
docker push suleonal/python-web-app:1.0.0
```
```sh
FROM python:3.9-slim AS base

WORKDIR /app
COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

RUN groupadd -g 1000 appuser && useradd -r -u 1000 -g appuser appuser
USER appuser

CMD ["python3", "app.py"] 
```
### PostgreSQL Installation
Relational database for storing application data.
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install postgres bitnami/postgresql -f default-values.yaml
```
```sh
primary:
  persistence:
    size: 4Gi
  service:
    nodePorts:
      postgresql: "30005"
    type: NodePort
global:
  postgresql:
    auth:
      existingSecret: postgresql-secrets
      password: ""
      postgresPassword: ""
      secretKeys:
        adminPasswordKey: postgres-password
        replicationPasswordKey: ""
        userPasswordKey: password
```
##### PostgreSQL Test Script:
 Verifies connection to the database, creates a test database and table, inserts data, queries it, and then cleans up.
 NOTE: Postgresql test scripts use a .env file to securely manage and load environment-specific configurations like host, user, password, and database details.
```sh
NAMESPACE=databases
PG_DB=testdb
PG_HOST=**************
PG_USER=**************
PG_PASSWORD=**************
```
```sh
./postgres-script.sh
```
```sh
#!/bin/bash

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found."
    exit 1
fi

POD_NAME=$(kubectl get pods -n $NAMESPACE | grep 'postgres-postgresql-' | awk '{print $1}' | head -n 1)

if [ -z "$POD_NAME" ]; then
    echo "PostgreSQL pod not found. Make sure the pod is running and has the 'app=postgresql' label."
    exit 1
fi

echo "PostgreSQL pod found: $POD_NAME"

# Check PostgreSQL connection
echo "Checking PostgreSQL connection..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -c "\conninfo" 
if [ $? -ne 0 ]; then
    echo "Unable to connect to PostgreSQL pod or connection failed."
    exit 1
fi
echo "PostgreSQL connection successful!"

# Create test database
echo "Creating test database..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -c "CREATE DATABASE $PG_DB;" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Test database creation failed. The database might already exist."
else
    echo "Test database created successfully."
fi

# Create table and insert data
echo "Creating table and inserting data..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -d $PG_DB <<EOF
CREATE TABLE test_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); INSERT INTO test_table (name) VALUES ('Test User');
EOF

if [ $? -ne 0 ]; then
    echo "Table creation or data insertion failed."
    exit 1
else
    echo "Table and data created successfully."
fi

# Query data from the database
echo "Querying data from the database..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -d $PG_DB -c "SELECT * FROM test_table;"

echo "Cleaning up..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    env PGPASSWORD=$PG_PASSWORD psql -h $PG_HOST -U $PG_USER -c "DROP DATABASE $PG_DB;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Test database dropped successfully."
else
    echo "Failed to drop test database."
fi

echo "PostgreSQL Kubernetes test script completed."
```
##### Automated Daily Backup of PostgreSQL Database:
It uses a Kubernetes CronJob and a Docker image to backup the PostgreSQL database daily and upload it to S3.
The Docker image used for backup includes PostgreSQL CLI and AWS CLI tools.
```sh
docker build -t aws-postgre-cli:latest .
```
```sh
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    sudo

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c | awk '{print $2}')-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y postgresql-client

RUN apt-get install -y awscli

CMD ["bash"]
```
The AWS credentials required to upload database backups to S3 must be defined as a Kubernetes Secret.
```sh
kubectl apply -f aws-secret.yaml -n databases
```
```sh
apiVersion: v1
kind: Secret
metadata:
  name: aws-secret
  namespace: databases
type: Opaque
data:
  aws-access-key: QUtJQVRQSEFCNTVVVk9YNFFMTk0=
  aws-secret-key: ZTcwdTFxeHJ1QzFYMHh6OHhsbjQvRGs4b2ZIYUdHTnVvelB2UzBjLw==
```
A CronJob must be defined for PostgreSQL backup.
```sh
kubectl apply -f kubectl apply -f postgresql-backup-cronjob.yaml -n databases
```
```sh
apiVersion: batch/v1
kind: CronJob
metadata:
  name: postgresql-backup
  namespace: databases
spec:
  schedule: "38 12 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: postgresql-backup
              image: suleonal/aws-postgre-cli:latest
              env:
                - name: POSTGRES_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: postgresql-secret
                      key: postgresql-password
                - name: POSTGRES_USER
                  valueFrom:
                    secretKeyRef:
                      name: postgresql-secret
                      key: postgresql-user
                - name: POSTGRES_DB
                  value: "app_db"
                - name: AWS_ACCESS_KEY_ID
                  valueFrom:
                    secretKeyRef:
                      name: aws-secret
                      key: aws-access-key
                - name: AWS_SECRET_ACCESS_KEY
                  valueFrom:
                    secretKeyRef:
                      name: aws-secret
                      key: aws-secret-key
                - name: AWS_DEFAULT_REGION
                  value: "eu-central-1"
                - name: S3_BUCKET
                  value: "workspace-docker-bucket"
              command:
                - /bin/bash
                - -c
                - |
                  TIMESTAMP=$(date "+%Y-%m-%d-%H%M%S")
                  BACKUP_FILE="/tmp/db_backup_${TIMESTAMP}.sql"

                  export PGPASSWORD=$POSTGRES_PASSWORD
                  echo "Creating PostgreSQL backup..."
                  pg_dump -U $POSTGRES_USER -d $POSTGRES_DB -h postgres-postgresql.databases.svc.cluster.local > $BACKUP_FILE

                  echo "Uploading backup file to S3..."
                  aws s3 cp $BACKUP_FILE s3://$S3_BUCKET/

                  echo "Backup process completed successfully!"
          restartPolicy: OnFailure
```
### Redis Installation
 In-memory data store for caching and session management.
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install redis bitnami/redis -f default-values.yaml
```
```sh
USER-SUPPLIED VALUES:
architecture: standalone
auth:
  enabled: true
  existingSecret: redis-secret
  existingSecretPasswordKey: redis-password
  password: ""
master:
  persistence:
    size: 2Gi
  service:
    nodePorts:
      redis: "30006"
    portNames:
      redis: tcp-redis
    ports:
      redis: 6379
    type: NodePort
```
##### Redis Test Script:
Confirms Redis connectivity, sets a test key-value pair, retrieves the value, and validates the result.
NOTE: Redis test scripts use a .env file to securely manage and load environment-specific configurations like host, user, password, and database details.
```sh
REDIS_HOST=***********
REDIS_PORT=6379
REDIS_PASSWORD=***********
NAMESPACE=databases
```
```sh
./redis-script.sh
```
```sh
#!/bin/bash

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo ".env file not found."
    exit 1
fi

POD_NAME=$(kubectl get pods -n $NAMESPACE --no-headers -o custom-columns=":metadata.name" | grep redis) # Redis Pod name

echo "Checking Redis connection..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD PING > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Unable to connect to Redis pod or connection failed."
    exit 1
fi 
echo "Redis connection successful!"

echo "Adding test data to Redis..."
kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD SET test_key "HelloRedis" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error occurred while adding test data."
    exit 1
fi

echo "Test data successfully added."

echo "Reading test data..."
TEST_VALUE=$(kubectl exec -n $NAMESPACE -it $POD_NAME -- \
    redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD GET test_key 2>&1 | sed -e 's/^Warning:.*//g' | xargs)

echo "Read value: '$TEST_VALUE'"

EXPECTED_VALUE="HelloRedis"

CLEAN_TEST_VALUE=$(echo "$TEST_VALUE" | tr -d '[:space:]')
CLEAN_EXPECTED_VALUE=$(echo "$EXPECTED_VALUE" | tr -d '[:space:]') 
if [ "$CLEAN_TEST_VALUE" == "$CLEAN_EXPECTED_VALUE" ]; then
    echo "Redis connection and data test successful!"
else
    echo "Redis data test failed."
    echo "Values are different: Read value: '$CLEAN_TEST_VALUE' Expected value: '$CLEAN_EXPECTED_VALUE'"
    exit 1
fi
```
### Converting an Application to a Helm Chart
Deployment and management in Kubernetes becomes easier. Helm helps package Kubernetes resources and manage deployments more efficiently by templating configuration values.
```sh
replicaCount: 1

image:
  repository: suleonal/python-web-app
  tag: "1.0.6"
  pullPolicy: IfNotPresent

postgres:
  host: postgres-postgresql.databases.svc.cluster.local
  port: 5432

redis:
  host: redis-master.databases.svc.cluster.local
  port: 6379

service:
  port: 5000
  targetPort: 5000
  nodePort: 30004
  type: NodePort
```
### Jenkins Installation and Setup
CI/CD server for automating application deployment pipelines.
```sh
helm repo add jenkinsci https://charts.jenkins.io
helm install jenkins jenkinsci/jenkins -n jenkins --create-namespace
```
#### Jenkins Configuration
Docker build and push operations will be performed with Kaniko without requiring Docker. First, a Container Template is created.
![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*MydwIO9goTM2KDMEdXn76w.png)
Next, a secret is generated from docker-config.json to enable Kaniko's authentication transactions with the registry.
![](https://miro.medium.com/v2/resize:fit:640/format:webp/1*wW6wM4S2I332T6Boop2Kyg.png)
```sh
kubectl create secret generic kaniko-secret — from-file=config.json — namespace=jenkins
```
Finally, a volume is created from the template in Jenkins Cloud.
![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*XruW-hf-lyyozD9m34_9BA.png)


The application's Docker image is then built using the Kaniko container within Jenkins Cloud.
```sh
stage('Kaniko Build & Push Image') {
            steps {
                container('kaniko') {
                    script {
			    def image = "docker.io/${env.DOCKER_REPO}:${env.DOCKER_TAGS}"
			    def context = "applications"
			    def dockerfile = "Dockerfile"
                            sh "/kaniko/executor --context ${context} --dockerfile ${dockerfile} --destination ${image}"
                    }
                }
            }
	}
```
### Chartmuseum Installation
By using ChartMuseum, we will store the application's Helm packages in a publicly accessible central repository. This way, when using ArgoCD, we can pull the Helm resources from there.
```sh
helm repo add chartmuseum https://chartmuseum.github.io/charts
helm install helm-repo chartmuseum/chartmuseum -f values.yaml
```
```sh
env:
  open:
    DISABLE_API: false
```
NOTE: 
Ensures that the application's API is active.

##### Helm Package And Helm Push:
Packages the Helm chart into a .tgz file and pushes it to a Helm chart repository for versioned storage and distribution. Here it creates a Container template again. 
Image: "alpine/helm:latest"
Container Name: helm
```sh
    stage('Modify Helm Values') {
	    steps {
        	script {
        		def valuesFile = "applications/helm/values.yaml"
        		def newTag = env.DOCKER_TAGS

        		echo "Updating image tag in Helm values file: ${newTag}"

        		sh """
        		   sed -i 's|^  tag:.*|  tag: "${newTag}"|' ${valuesFile}
        		"""
        		sh "cat ${valuesFile} | grep '  tag:'"
        	}
    	}	
    }
	stage('Modify Chart Version') {
            steps {
                script {
                    sh """#!/bin/bash
                       # Current version
                       cat applications/helm/Chart.yaml | grep version

                       # Update version using sed
                       sed -i 's|version: .*|version: "${VERSION}"|' applications/helm/Chart.yaml

                       # Updated version
                       cat applications/helm/Chart.yaml | grep version
                    """
                }
            }
        }
        stage('Package with Helm') {
            steps {
		        container('helm') {
	 	            script{
                	    sh "helm package applications/helm/."
                    }
            	}
            }
	    }
	    stage('Helm Push') {
            steps {
                container('helm') {
                    sh "echo \"@${FULL_CHART_NAME}\""
		            sh "cd applications/helm"
		            sh "curl --data-binary \"@${FULL_CHART_NAME}\" -H \"Content-Type: application/x-gzip\" http://helm-repo-chartmuseum.default.svc.cluster.local:8080/api/charts"
                }
            }
        }
```
### ArgoCD Installation and Deployment
GitOps tool for Kubernetes application deployments.
```sh
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd --create-namespace --set server.service.type=NodePort
```
##### Deploy Applications to Kubernetes with Argocd:
```sh
kubectl apply -f museum-creds.yaml -n argocd
kubectl apply -f project.yaml -n argocd
kubectl apply -f applications.yaml -n argocd
```
Creates a Secret containing the credentials needed for ArgoCD to access the ChartMuseum repository.
```sh
apiVersion: v1
kind: Secret
metadata:
  name: museum-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  project: python
  type: helm
  url: http://helm-repo-chartmuseum.default.svc.cluster.local:8080
```
An AppProject must be defined for ArgoCD and the resources required to deploy applications to the application namespace using Helm charts from the ChartMuseum repository.
```sh
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: python
spec:
  description: "Python project"
  sourceRepos:
    - 'http://helm-repo-chartmuseum.default.svc.cluster.local:8080'
  destinations:
    - namespace: applications
      server: 'https://kubernetes.default.svc'
```
An Application must be defined for ArgoCD and we must configure it to deploy the python-web-app chart from ChartMuseum into the application namespace. The application is kept up to date with automatic synchronization and self-healing features.
```sh
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: python-app
spec:
  destination:
    name: ''
    namespace: applications
    server: 'https://kubernetes.default.svc'
  project: python
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  sources:
  - repoURL: 'http://helm-repo-chartmuseum.default.svc.cluster.local:8080'
    chart: python-web-app
    targetRevision: '*'
```
