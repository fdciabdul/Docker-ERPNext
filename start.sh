#!/bin/bash

set -e

echo "ERPNext Docker Setup - Quick Start"
echo "=================================="
echo ""

if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo "Error: Docker Compose is not installed"
    exit 1
fi

if [ ! -f .env ]; then
    echo "Creating .env file from example..."
    cp env.example .env
    echo "Please edit .env file with your passwords before continuing"
    read -p "Press enter to continue after editing .env..."
fi

echo ""
echo "Starting ERPNext containers..."
docker compose up -d

echo ""
echo "Waiting for services to be ready..."
sleep 10

echo ""
echo "Checking service status..."
docker compose ps

echo ""
echo "=================================="
echo "Setup complete!"
echo ""
echo "ERPNext will be available at: http://localhost:8080"
echo "Default credentials:"
echo "  Username: Administrator"
echo "  Password: admin (or what you set in .env)"
echo ""
echo "Note: Initial site creation may take 5-10 minutes"
echo "Monitor progress with: docker compose logs -f create-site"
echo "=================================="
