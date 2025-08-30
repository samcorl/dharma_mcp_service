#!/bin/bash

# Dharma MCP Service Production Deployment Script

set -e

echo "🚀 Deploying Dharma MCP Service to production..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please copy .env.example to .env and configure your environment variables."
    exit 1
fi

# Source environment variables
source .env

# Validate required environment variables
if [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$RAILS_MASTER_KEY" ]; then
    echo "❌ Required environment variables are not set. Please check your .env file."
    echo "Required: MYSQL_PASSWORD, MYSQL_ROOT_PASSWORD, RAILS_MASTER_KEY"
    exit 1
fi

echo "📦 Building production images..."
docker-compose -f docker-compose.production.yml build --no-cache

echo "🗄️ Setting up database..."
docker-compose -f docker-compose.production.yml run --rm app rails db:create db:migrate db:seed

echo "🔄 Starting services..."
docker-compose -f docker-compose.production.yml up -d

echo "🏥 Checking service health..."
sleep 10

# Check if app is responding
if curl -f http://localhost:3000/up > /dev/null 2>&1; then
    echo "✅ Application is healthy!"
else
    echo "❌ Application health check failed. Checking logs..."
    docker-compose -f docker-compose.production.yml logs app
    exit 1
fi

echo "🎉 Deployment complete!"
echo "📍 MCP Server is running at http://localhost:3000"
echo "🔧 MCP Tools endpoint: http://localhost:3000/mcp/tools/list"
echo ""
echo "To view logs: docker-compose -f docker-compose.production.yml logs -f"
echo "To stop: docker-compose -f docker-compose.production.yml down"