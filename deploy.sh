#!/bin/bash

echo "===== Deployment Started: $(date) ====="

# Navigate to home directory
cd /home/ec2-user

# Download latest artifact from S3
echo "Pulling latest artifact from S3..."
aws s3 cp s3://nandana-deployment-artifacts/artifact.zip . --region ap-south-1

# Clean old deployment
echo "Cleaning old deployment..."
rm -rf myapp
mkdir myapp

# Extract new artifact
echo "Extracting artifact..."
unzip -o artifact.zip -d myapp
cd myapp

# Set RDS environment variables
export DB_HOST=appdb-instance.cf6y4ga6mva7.ap-south-1.rds.amazonaws.com
export DB_USER=admin
export DB_PASSWORD=Adminnandana123
export DB_NAME=appdb
export PORT=8080

# Install dependencies
echo "Installing dependencies..."
npm install

# Install PM2 globally if not already installed
pm2 --version 2>/dev/null || sudo npm install -g pm2

# Start or restart application with PM2
echo "Starting application..."
pm2 stop myapp 2>/dev/null || true
pm2 start server.js --name myapp

echo "===== Deployment Finished: $(date) ====="
pm2 status