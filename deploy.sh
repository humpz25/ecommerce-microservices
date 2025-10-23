#!/bin/bash
set -e

echo "Updating system..."
sudo apt update -y

echo "Installing prerequisites..."
sudo apt install -y git curl

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu || true

echo "Navigating to repository..."
cd ~/ecommerce-microservices

echo "Pulling latest changes..."
git pull || true

echo "Stopping existing containers..."
sudo docker compose down || true

echo "Building and starting containers..."
sudo docker compose up -d --build
