#!/bin/bash

# N8N Deploy Script
# This script pushes changes and updates the server

set -e

echo "🚀 Deploying n8n changes..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  You have uncommitted changes. Please commit them first."
    echo "📋 Uncommitted changes:"
    git status --short
    exit 1
fi

# Push changes to repository
echo "📤 Pushing changes to repository..."
git push origin main

# SSH into server and run update
echo "🔄 Updating server..."
ssh ubuntu@3.16.10.208 "update-n8n"

echo "✅ Deployment completed successfully!"
echo "🌐 N8N is available at: https://n8n.yudaicreator.com"