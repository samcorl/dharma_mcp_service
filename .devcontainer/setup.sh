#!/bin/bash

# Dharma MCP Service DevContainer Setup Script
# For developers learning Ruby and Rails

set -e

echo "🚀 Setting up Dharma MCP Service development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to wait for database
wait_for_database() {
    print_status "Waiting for MySQL database to be ready..."
    
    max_attempts=30
    attempt=0
    
    while ! mysqladmin ping -h db -u dharma_user -ppassword --silent; do
        attempt=$((attempt + 1))
        if [ $attempt -eq $max_attempts ]; then
            print_error "Database failed to become ready after $max_attempts attempts"
            exit 1
        fi
        print_status "Database not ready yet (attempt $attempt/$max_attempts)..."
        sleep 2
    done
    
    print_success "Database is ready!"
}

# Function to install Ruby gems
install_gems() {
    print_status "Installing Ruby gems..."
    
    # Install bundler if not present
    if ! gem list bundler -i > /dev/null 2>&1; then
        gem install bundler
    fi
    
    # Install gems
    bundle config set --local path '/usr/local/bundle'
    bundle install
    
    print_success "Gems installed successfully!"
}

# Function to setup database
setup_database() {
    print_status "Setting up Rails database..."
    
    # Check if database exists
    if rails db:version > /dev/null 2>&1; then
        print_status "Database already exists, running migrations..."
        rails db:migrate
    else
        print_status "Creating database and running migrations..."
        rails db:create
        rails db:migrate
    fi
    
    # Check if seed data exists
    if [ $(rails runner "puts Product.count") -eq 0 ] 2>/dev/null; then
        print_status "Seeding database with sample data..."
        rails db:seed
    else
        print_status "Database already has data, skipping seed"
    fi
    
    print_success "Database setup complete!"
}

# Function to setup Claude Code
setup_claude_code() {
    print_status "Setting up Claude Code configuration..."
    
    # Ensure Claude Code config directory exists with proper permissions
    mkdir -p /home/vscode/.config/claude-code
    chown -R vscode:vscode /home/vscode/.config/claude-code
    
    # Create Claude Code settings if they don't exist
    if [ ! -f /home/vscode/.config/claude-code/settings.json ]; then
        cat > /home/vscode/.config/claude-code/settings.json << 'EOF'
{
  "workspaceSettings": {
    "alwaysAllowReadWorkspace": true,
    "enableShellCommands": true,
    "enableFileOperations": true
  },
  "defaultModel": "claude-3-5-sonnet-20241022",
  "maxTokens": 8192
}
EOF
        chown vscode:vscode /home/vscode/.config/claude-code/settings.json
        print_success "Created Claude Code settings file"
    else
        print_status "Claude Code settings already exist"
    fi
    
    # Set up Claude Code auth if API key is available
    if [ ! -z "$ANTHROPIC_API_KEY" ]; then
        print_status "ANTHROPIC_API_KEY found, configuring authentication..."
        su -c "echo '$ANTHROPIC_API_KEY' | claude-code auth" vscode
        print_success "Claude Code authentication configured"
    else
        print_warning "ANTHROPIC_API_KEY not set. You'll need to run 'claude-code auth' manually"
    fi
    
    print_success "Claude Code setup complete!"
}

# Function to create helpful files for beginners
create_helper_files() {
    print_status "Creating helpful files for Ruby beginners..."
    
    # Create a test API requests file
    cat > api_tests.http << 'EOF'
### Health Check
GET http://localhost:3000/up

### List MCP Tools
GET http://localhost:3000/mcp/tools/list

### Search Products (Cotton Dyes)
POST http://localhost:3000/mcp/tools/call
Content-Type: application/json

{
  "name": "search_products",
  "arguments": {
    "fiber_type": "cotton",
    "query": "dye"
  }
}

### Get Product Details
POST http://localhost:3000/mcp/tools/call
Content-Type: application/json

{
  "name": "get_product_details",
  "arguments": {
    "product_id": 1
  }
}

### Check Fiber Compatibility
POST http://localhost:3000/mcp/tools/call
Content-Type: application/json

{
  "name": "check_compatibility",
  "arguments": {
    "product_id": 1,
    "fiber_type": "cotton"
  }
}

### Search Support Content
POST http://localhost:3000/mcp/tools/call
Content-Type: application/json

{
  "name": "search_support",
  "arguments": {
    "query": "fiber reactive dye"
  }
}
EOF

    # Create Ruby learning cheat sheet
    cat > RUBY_CHEATSHEET.md << 'EOF'
# Ruby on Rails Cheat Sheet for Dharma MCP

## Useful Commands

### Rails Console (Interactive Ruby)
```bash
rails console
# or shorter:
rails c
```

### Database Commands
```bash
rails db:create     # Create database
rails db:migrate    # Run migrations
rails db:seed       # Load seed data
rails db:reset      # Drop, create, migrate, seed
rails db:rollback   # Undo last migration
```

### Server Commands
```bash
rails server        # Start server
rails server -p 3001  # Start on different port
```

### Testing
```bash
rails test          # Run all tests
rails test test/models/product_test.rb  # Run specific test
```

## Ruby Basics

### Variables
```ruby
name = "Dharma MCP"           # String
price = 3.95                  # Float
count = 5                     # Integer
active = true                 # Boolean
products = []                 # Array
user = {}                     # Hash
```

### Rails Models (Database)
```ruby
# Find records
Product.all                   # Get all products
Product.find(1)              # Find by ID
Product.where(active: true)   # Filter records
Product.first                # First record
Product.last                 # Last record

# Create records
product = Product.new(name: "Red Dye", price: 3.95)
product.save

# Or create in one step
Product.create!(name: "Blue Dye", price: 4.50)
```

### Rails Routes
Check `config/routes.rb` for all available endpoints.

### Debugging
Add `binding.break` to any Ruby file to create a breakpoint.

## Project Structure
```
app/
  controllers/     # Handle HTTP requests
  models/         # Database models
  views/          # HTML templates (not used in API mode)
config/
  database.yml    # Database configuration
  routes.rb       # URL routing
db/
  migrate/        # Database migrations
  seeds.rb        # Sample data
```

## MCP Development

### Adding New MCP Tools
1. Add tool definition to `tools_list` method in `app/controllers/mcp_controller.rb`
2. Add case statement to `call_tool` method
3. Implement the tool method
4. Test with HTTP file or curl

### Common Rails Patterns
```ruby
# Controller pattern
def index
  @products = Product.all
  render json: @products
end

# Model associations
class Product < ApplicationRecord
  belongs_to :product_family
  has_many :product_variants
end
```

Happy coding! 🚀
EOF

    # Create VS Code tasks
    mkdir -p .vscode
    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Start Rails Server",
            "type": "shell",
            "command": "rails server",
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            },
            "problemMatcher": []
        },
        {
            "label": "Rails Console",
            "type": "shell",
            "command": "rails console",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": true,
                "panel": "new"
            }
        },
        {
            "label": "Run Tests",
            "type": "shell",
            "command": "rails test",
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Database Reset",
            "type": "shell",
            "command": "rails db:reset",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        }
    ]
}
EOF

    # Create launch configuration for debugging
    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Rails Server",
            "type": "Ruby",
            "request": "launch",
            "program": "${workspaceRoot}/bin/rails",
            "args": ["server"],
            "cwd": "${workspaceRoot}",
            "env": {
                "RAILS_ENV": "development"
            }
        },
        {
            "name": "Debug Rails Console",
            "type": "Ruby", 
            "request": "launch",
            "program": "${workspaceRoot}/bin/rails",
            "args": ["console"],
            "cwd": "${workspaceRoot}",
            "env": {
                "RAILS_ENV": "development"
            }
        }
    ]
}
EOF

    print_success "Helper files created!"
}

# Function to display helpful information
show_startup_info() {
    print_success "🎉 Dharma MCP Service development environment is ready!"
    echo ""
    echo "📚 For Ruby beginners:"
    echo "   • Check RUBY_CHEATSHEET.md for Ruby/Rails basics"
    echo "   • Use api_tests.http to test MCP endpoints (with REST Client extension)"
    echo "   • Press Ctrl+Shift+P and type 'Tasks' to run common Rails commands"
    echo ""
    echo "🚀 Getting started:"
    echo "   1. Start Rails server: rails server (or use VS Code task)"
    echo "   2. Open http://localhost:3000/up to test"
    echo "   3. Try MCP tools at http://localhost:3000/mcp/tools/list"
    echo "   4. Open Rails console: rails console (or use VS Code task)"
    echo ""
    echo "🗄 Database:"
    echo "   • MySQL is running on port 3306"
    echo "   • Use the MySQL extension in VS Code to browse data"
    echo "   • Database name: dharma_mcp_development"
    echo ""
    echo "🛠 Development commands:"
    echo "   • rails test           - Run tests"
    echo "   • rails db:migrate     - Apply database changes"
    echo "   • rails db:console     - Database console"
    echo "   • bundle install       - Install gems"
    echo "   • claude-code          - Start Claude Code CLI"
    echo ""
    echo "📡 MCP Tools available:"
    echo "   • search_products      - Find products by fiber, skill level"
    echo "   • check_compatibility  - Verify dye/fiber compatibility"  
    echo "   • get_technique_guide  - Step-by-step instructions"
    echo "   • search_support       - FAQ and help articles"
    echo ""
    echo "Happy coding! 🧵🎨"
}

# Main setup sequence
main() {
    print_status "Starting Dharma MCP Service setup..."
    
    # Wait for database to be ready
    wait_for_database
    
    # Install gems
    install_gems
    
    # Setup database
    setup_database
    
    # Setup Claude Code
    setup_claude_code
    
    # Create helper files
    create_helper_files
    
    # Display startup information
    show_startup_info
    
    print_success "Setup completed successfully! 🎉"
}

# Run main function
main "$@"