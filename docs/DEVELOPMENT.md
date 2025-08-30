# Development Guide

This guide covers local development setup and workflows for the Dharma MCP Service.

## Prerequisites

- Ruby 3.2.2
- MySQL 8.0 (or Docker)
- Git

## Local Development Setup

### Option 1: Native Development

#### 1. Install Dependencies
```bash
# Install Ruby (using rbenv)
rbenv install 3.2.2
rbenv local 3.2.2

# Install Bundler
gem install bundler

# Install gems
bundle install
```

#### 2. Setup Database
```bash
# Install MySQL (macOS)
brew install mysql
brew services start mysql

# Create database user
mysql -u root -p
CREATE USER 'dharma_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON dharma_mcp_development.* TO 'dharma_user'@'localhost';
GRANT ALL PRIVILEGES ON dharma_mcp_test.* TO 'dharma_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### 3. Setup Rails Application
```bash
# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start server
rails server
```

### Option 2: DevContainer Development (Recommended)

#### 1. Prerequisites
- Docker Desktop
- Visual Studio Code
- Dev Containers extension

#### 2. Open in DevContainer
```bash
# Clone repository
git clone <your-repo-url>
cd dharma_mcp_service

# Open in VS Code
code .

# When prompted, click "Reopen in Container"
# Or use Command Palette: "Dev Containers: Reopen in Container"
```

The devcontainer will automatically:
- Setup Ruby environment
- Install dependencies
- Start MySQL service
- Run database setup

### Option 3: Docker Compose Development

#### 1. Local Docker Development
```bash
# Start development services
docker-compose -f docker-compose.dev.yml up -d

# Setup database
docker-compose -f docker-compose.dev.yml exec app rails db:create db:migrate db:seed

# View logs
docker-compose -f docker-compose.dev.yml logs -f app
```

## Development Workflow

### Running Tests
```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/product_test.rb

# Run tests with coverage
bundle exec rails test

# Check code quality
bundle exec rubocop
bundle exec brakeman
```

### Database Operations
```bash
# Create and run new migration
rails generate migration AddFieldToProducts field:string
rails db:migrate

# Rollback migration
rails db:rollback

# Reset database
rails db:drop db:create db:migrate db:seed

# Open database console
rails dbconsole

# Open Rails console
rails console
```

### Adding New MCP Tools

#### 1. Add Tool Definition
Add to `app/controllers/mcp_controller.rb` in the `tools_list` method:

```ruby
{
  name: "new_tool_name",
  description: "Description of what the tool does",
  inputSchema: {
    type: "object",
    properties: {
      param1: { type: "string", description: "Parameter description" }
    },
    required: ["param1"]
  }
}
```

#### 2. Implement Tool Logic
Add case in `call_tool` method:

```ruby
when 'new_tool_name'
  new_tool_name(arguments)
```

#### 3. Create Tool Method
```ruby
def new_tool_name(args)
  # Implementation logic
  results = YourModel.where(...)
  
  render json: { results: results }
rescue => e
  render json: { error: "Internal error: #{e.message}" }, status: 500
end
```

#### 4. Test the Tool
```bash
# Test via curl
curl -X POST http://localhost:3000/mcp/tools/call \
  -H "Content-Type: application/json" \
  -d '{
    "name": "new_tool_name",
    "arguments": {
      "param1": "test_value"
    }
  }'
```

### Model Development

#### Creating New Models
```bash
# Generate model with attributes
rails generate model ModelName attribute1:string attribute2:text

# Generate model with associations
rails generate model Order product:references quantity:integer
```

#### Adding Associations
```ruby
# In app/models/product.rb
class Product < ApplicationRecord
  belongs_to :product_family
  has_many :product_variants
  has_and_belongs_to_many :tags
end
```

#### Adding Validations
```ruby
class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: true
end
```

### Seeding Data

Edit `db/seeds.rb` to add development data:

```ruby
# Create test data using find_or_create_by for idempotency
product = Product.find_or_create_by!(sku: "TEST-001") do |p|
  p.name = "Test Product"
  p.description = "A test product for development"
  p.price = 10.99
  # ... other attributes
end
```

### Environment Configuration

#### Development Environment Variables
Create `.env.development`:
```env
DATABASE_HOST=localhost
DATABASE_PASSWORD=password
RAILS_LOG_LEVEL=debug
```

#### Test Environment
Create `.env.test`:
```env
DATABASE_PASSWORD=password
RAILS_ENV=test
```

### Debugging

#### Rails Console Debugging
```ruby
# In rails console
Product.all
Product.find(1)
Product.where(name: "Test")

# Debug queries
ActiveRecord::Base.logger = Logger.new(STDOUT)
```

#### Using Debugger
Add to your code:
```ruby
binding.break  # Ruby 3.1+
# or
debugger      # older versions
```

#### View Logs
```bash
# Development logs
tail -f log/development.log

# Test logs  
tail -f log/test.log

# SQL queries
tail -f log/development.log | grep SELECT
```

### Code Quality

#### Running Linters
```bash
# RuboCop (style guide)
bundle exec rubocop
bundle exec rubocop --auto-correct

# Brakeman (security)
bundle exec brakeman

# Rails Best Practices
bundle exec rails_best_practices .
```

#### Pre-commit Hooks
```bash
# Install pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
bundle exec rubocop --display-cop-names --extra-details
exit $?
EOF

chmod +x .git/hooks/pre-commit
```

## API Testing

### Manual Testing with curl
```bash
# List tools
curl http://localhost:3000/mcp/tools/list | jq

# Search products
curl -X POST http://localhost:3000/mcp/tools/call \
  -H "Content-Type: application/json" \
  -d '{
    "name": "search_products",
    "arguments": {"query": "dye", "fiber_type": "cotton"}
  }' | jq
```

### Using HTTPie (Alternative)
```bash
# Install HTTPie
pip install httpie

# List tools
http GET localhost:3000/mcp/tools/list

# Call tool
http POST localhost:3000/mcp/tools/call \
  name=search_products \
  arguments:='{"query": "dye"}'
```

## Performance Testing

### Load Testing with Apache Bench
```bash
# Install Apache Bench
brew install apache-bench  # macOS

# Basic load test
ab -n 1000 -c 10 http://localhost:3000/mcp/tools/list

# POST request test
ab -n 100 -c 5 -T application/json \
   -p post_data.json \
   http://localhost:3000/mcp/tools/call
```

### Database Query Optimization
```ruby
# Use includes to avoid N+1 queries
products = Product.includes(:product_family, :product_variants)

# Use select to limit columns
products = Product.select(:id, :name, :price)

# Add database indexes in migrations
add_index :products, :sku
add_index :products, [:product_family_id, :active]
```

## Deployment Testing

### Local Production Build
```bash
# Build production image
docker build -t dharma-mcp-prod .

# Run production container
docker run -p 3000:3000 \
  -e RAILS_MASTER_KEY=your_key \
  -e DATABASE_URL=mysql2://user:pass@host/db \
  dharma-mcp-prod
```

### Staging Environment
```bash
# Deploy to staging
git push staging main

# Run migrations on staging
heroku run rails db:migrate -a dharma-mcp-staging

# Check staging logs
heroku logs -t -a dharma-mcp-staging
```

## Troubleshooting

### Common Issues

1. **Database connection errors**
   ```bash
   # Check MySQL is running
   brew services list | grep mysql
   
   # Check database exists
   rails db:create
   ```

2. **Gem installation issues**
   ```bash
   # Clear gem cache
   gem cleanup
   
   # Reinstall bundle
   rm Gemfile.lock
   bundle install
   ```

3. **Port already in use**
   ```bash
   # Kill process on port 3000
   lsof -ti:3000 | xargs kill -9
   
   # Or use different port
   rails server -p 3001
   ```

4. **Docker issues**
   ```bash
   # Clean Docker
   docker system prune -af
   
   # Rebuild containers
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

### Getting Help

1. Check application logs
2. Review this documentation
3. Search GitHub issues
4. Ask team members

## Contributing

1. Create feature branch: `git checkout -b feature/new-tool`
2. Make changes and test locally
3. Run code quality checks: `bundle exec rubocop`
4. Create pull request with description
5. Ensure CI passes
6. Get code review approval