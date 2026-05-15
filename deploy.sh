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
export DB_HOST=YOUR-RDS-ENDPOINT-GOES-HERE
export DB_USER=admin
export DB_PASSWORD=YOUR-RDS-PASSWORD-GOES-HERE
export DB_NAME=appdb
export PORT=8080

# Install dependencies
echo "Installing dependencies..."
npm install

# Start or restart application with PM2
echo "Starting application..."
pm2 stop myapp 2>/dev/null || true
pm2 start server.js --name myapp --env production

echo "===== Deployment Finished: $(date) ====="
pm2 status