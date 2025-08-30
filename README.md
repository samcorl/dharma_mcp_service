# README

# Dharma MCP Service

A Rails-based MCP (Model Context Protocol) server for intelligent fiber arts customer assistance.

## 🚀 Quick Start

### Docker Deployment (Recommended)
```bash
git clone <repo-url>
cd dharma_mcp_service
cp .env.example .env
# Edit .env with your database credentials
./deploy.sh
```

### Local Development
```bash
bundle install
rails db:create db:migrate db:seed  
rails server
```

## 📋 Features

- **Product Search**: Find products by fiber type, technique, skill level
- **Compatibility Checking**: Verify dye/fiber compatibility
- **Project Guidance**: Complete supply lists for fiber arts projects
- **Agent Support**: Contextual guidance for MCP agents
- **Technical Instructions**: Step-by-step crafting guides

## 🔗 MCP Tools

Access the MCP server at:
- **Tools List**: `GET /mcp/tools/list`
- **Tool Execution**: `POST /mcp/tools/call`

## 📚 Documentation

See the [`docs/`](docs/) directory for comprehensive documentation:

- [📖 Complete Documentation](docs/README.md)
- [🚀 AWS EC2 Deployment](docs/DEPLOYMENT.md)
- [🛠 Development Guide](docs/DEVELOPMENT.md)
- [📡 API Reference](docs/API.md)
- [🗄 Database Schema](docs/DATABASE.md)

## 🧪 Quick Test

```bash
# Test health endpoint
curl http://localhost:3000/up

# List available MCP tools
curl http://localhost:3000/mcp/tools/list

# Search for cotton dyes
curl -X POST http://localhost:3000/mcp/tools/call \
  -H "Content-Type: application/json" \
  -d '{"name": "search_products", "arguments": {"fiber_type": "cotton", "query": "dye"}}'
```

## 🔧 Tech Stack

- **Backend**: Ruby on Rails 7.2 (API mode)
- **Database**: MySQL 8.0 with utf8mb4 encoding
- **Deployment**: Docker + Docker Compose + Nginx
- **Development**: DevContainer support

Perfect for deployment on AWS EC2 Ubuntu containers!
