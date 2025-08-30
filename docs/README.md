# Dharma MCP Service Documentation

Welcome to the Dharma MCP Service documentation. This service provides Model Context Protocol (MCP) tools for fiber arts agents to help customers with product recommendations, compatibility checking, and project guidance.

## Quick Links

- [🚀 Deployment Guide](DEPLOYMENT.md) - Deploy to AWS EC2
- [🛠 Development Guide](DEVELOPMENT.md) - Local development setup  
- [📡 API Documentation](API.md) - MCP tools and endpoints
- [🗄 Database Schema](DATABASE.md) - Models and relationships

## Overview

The Dharma MCP Service is a Rails API application that serves as an intelligent assistant for fiber arts customers. It provides:

### 🎯 Core Features

- **Product Search & Discovery**: Find products by fiber type, technique, skill level
- **Compatibility Checking**: Verify dye/fiber compatibility  
- **Project Guidance**: Complete supply lists for specific projects
- **Technique Instructions**: Step-by-step guides for fiber arts techniques
- **Agent Guidance**: Contextual help when agents get stuck
- **Support Integration**: FAQ and article search

### 🧠 Smart Agent Features

- **Contextual Guidance**: Automatic suggestions when searches fail or return too many results
- **Fiber Compatibility**: Intelligent matching of products to fiber types
- **Skill-Level Awareness**: Recommendations tailored to crafter experience
- **Project-Based Suggestions**: Complete material lists with quantities

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│                 │    │                 │    │                 │
│   MCP Client    │◄──►│   Rails API     │◄──►│   MySQL DB      │
│   (Claude)      │    │   (MCP Server)  │    │   (Data Store)  │
│                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Tech Stack

- **Backend**: Ruby on Rails 7.2 (API mode)
- **Database**: MySQL 8.0
- **Deployment**: Docker + Docker Compose
- **Web Server**: Puma + Nginx
- **Development**: DevContainer support

## Data Model

### Core Models

- **Product**: Main product catalog with fiber compatibility
- **ProductFamily**: Product groupings (Cotton Fabrics, Wool Yarns)
- **ProductCategory**: Categories (Dyes, Yarns, Tools)
- **ProductVariantList**: Color/size variants with inventory

### Content Models  

- **CraftInstructionsPage**: Tutorial content
- **TechniqueGuide**: Step-by-step technique instructions
- **ProjectIdea**: Complete project suggestions
- **AgentGuidance**: Contextual help for agents

### Support Models

- **FrequentlyAskedQuestion**: FAQ content
- **SupportArticle**: Help articles
- **ProductRecommendation**: "Customers also bought" logic

## Quick Start

### 🐳 Docker (Recommended)

```bash
# Clone repository
git clone <your-repo-url>
cd dharma_mcp_service

# Copy environment file
cp .env.example .env
# Edit .env with your settings

# Deploy
./deploy.sh
```

### 🛠 Local Development

```bash
# Install dependencies
bundle install

# Setup database  
rails db:create db:migrate db:seed

# Start server
rails server

# Test MCP endpoint
curl http://localhost:3000/mcp/tools/list
```

### ☁️ AWS EC2 Deployment

Follow the [deployment guide](DEPLOYMENT.md) for complete AWS setup instructions.

## Usage Examples

### Search Products by Fiber Type

```bash
curl -X POST http://localhost:3000/mcp/tools/call \
  -H "Content-Type: application/json" \
  -d '{
    "name": "search_products",
    "arguments": {
      "fiber_type": "cotton",
      "skill_level": "beginner"
    }
  }'
```

### Check Dye Compatibility

```bash
curl -X POST http://localhost:3000/mcp/tools/call \
  -H "Content-Type: application/json" \
  -d '{
    "name": "check_compatibility", 
    "arguments": {
      "product_id": 1,
      "fiber_type": "cotton"
    }
  }'
```

### Get Project Suggestions

```bash
curl -X POST http://localhost:3000/mcp/tools/call \
  -H "Content-Type: application/json" \
  -d '{
    "name": "suggest_for_project",
    "arguments": {
      "project_type": "scarf",
      "skill_level": "beginner"
    }
  }'
```

## Agent Integration

The service is designed to work with Claude and other MCP-compatible agents:

1. **Agent discovers tools** via `/mcp/tools/list`
2. **Agent calls tools** via `/mcp/tools/call` with parameters  
3. **Service provides results** with contextual guidance
4. **Agent assists customer** with intelligent recommendations

### Example Agent Conversation

```
User: "I want to dye a cotton t-shirt red. What do I need?"

Agent: Let me search for cotton-compatible red dyes.
[Calls search_products with fiber_type="cotton", color="red"]

Agent: I found Dharma Fiber Reactive Dye in red that's perfect for cotton! 
It works on cotton, rayon, linen, and other cellulose fibers. For a beginner, 
you'll also need soda ash as a fixative. Let me get you the complete supply list.

[Calls suggest_for_project with project_type="dye", fiber_type="cotton"]

Agent: Here's everything you need:
- Dharma Fiber Reactive Dye - Red ($3.95)
- Soda Ash Fixer ($4.50)  
- Rubber gloves
- Plastic bucket
- Salt for the dye bath

Would you like step-by-step dyeing instructions too?
```

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Follow the [development guide](DEVELOPMENT.md)
4. Run tests: `rails test`
5. Submit pull request

## Support

- **Documentation**: Check the relevant guide in this docs folder
- **Development Issues**: See [DEVELOPMENT.md](DEVELOPMENT.md)
- **Deployment Issues**: See [DEPLOYMENT.md](DEPLOYMENT.md)
- **API Questions**: See [API.md](API.md)

## License

[Add your license information here]

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and updates.