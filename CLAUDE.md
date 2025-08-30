# Claude Code Configuration for Dharma MCP Service

This project is configured to work with Claude Code in a DevContainer environment.

## Setup

1. **Set your API key** (required):
   ```bash
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```

2. **Rebuild the devcontainer** after setting the API key to ensure it's available during setup.

3. **Claude Code will be automatically configured** during container startup with:
   - Persistent settings stored in Docker volume
   - Workspace permissions enabled
   - Shell commands and file operations enabled
   - Default model set to Claude 3.5 Sonnet

## Usage

- Start Claude Code: `claude-code`
- Settings persist between container rebuilds
- All project files are accessible to Claude Code
- Database connection configured for development

## Project Context

This is a Ruby on Rails MCP (Model Context Protocol) server for Dharma Trading Company's fiber arts products. Key areas:

### Models
- `Product` - Dyes, fabrics, tools
- `ProductFamily` - Product categories  
- `ProductVariant` - Size/color variants
- `FiberType` - Fabric types (cotton, silk, etc.)
- `ProductRecommendation` - AI-generated suggestions

### Controllers
- `McpController` - Main MCP protocol implementation
- Tools: search_products, check_compatibility, get_technique_guide, search_support

### Database
- MySQL 8.0 running in container
- Seeded with sample fiber arts data
- Connection: host=db, database=dharma_mcp_development

### Testing
- Run tests: `rails test`
- Test MCP endpoints using `api_tests.http`

## Common Commands

```bash
# Development
rails server              # Start server on port 3000
rails console             # Interactive Ruby console
rails test                # Run test suite

# Database
rails db:migrate          # Apply migrations
rails db:seed             # Load sample data
rails db:console          # Database console

# Claude Code
claude-code               # Start Claude Code CLI
claude-code auth          # Authenticate (if needed)
```

## File Structure Priority

When working on this project, focus on:
1. `app/controllers/mcp_controller.rb` - MCP protocol implementation
2. `app/models/` - Data models and business logic
3. `db/seeds.rb` - Sample data for testing
4. `config/routes.rb` - API endpoints
5. `test/` - Test files

## Claude Desktop MCP Integration

You can also test this MCP server with Claude Desktop locally:

### 1. Install Claude Desktop
- Download from [claude.ai/desktop](https://claude.ai/desktop)
- Install and sign in with your Anthropic account

### 2. Configure MCP Server
Add to your Claude Desktop MCP configuration file:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "dharma-mcp": {
      "command": "ruby",
      "args": ["-r", "net/http", "-r", "json", "-e", "
        require 'webrick'
        server = WEBrick::HTTPServer.new(:Port => 3000)
        trap 'INT' do server.shutdown end
        server.start
      "],
      "cwd": "/path/to/dharma_mcp_service",
      "env": {
        "RAILS_ENV": "development"
      }
    }
  }
}
```

### 3. Alternative: HTTP MCP Bridge
For easier setup, use the HTTP bridge approach:

```json
{
  "mcpServers": {
    "dharma-mcp": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-http", "http://localhost:3000/mcp"],
      "env": {}
    }
  }
}
```

### 4. Start the Rails Server
```bash
# In your project directory
bundle exec rails server -p 3000
```

### 5. Restart Claude Desktop
- Close Claude Desktop completely
- Reopen it - the MCP server will connect automatically
- You'll see "dharma-mcp" in the server list at the bottom

### 6. Test MCP Tools
In Claude Desktop, you can now ask:
- "Search for cotton dyes suitable for beginners"
- "Check if fiber reactive dyes work with silk"
- "Find technique guides for batik"
- "What support articles mention indigo dyeing?"

### Troubleshooting
- Check Rails server is running on port 3000
- Verify MCP config file syntax (use JSON validator)
- Restart Claude Desktop after config changes
- Check Rails logs for MCP tool calls: `tail -f log/development.log`

Happy coding! 🧵✨