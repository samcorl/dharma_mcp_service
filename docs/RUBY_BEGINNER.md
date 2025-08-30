# Ruby Beginner's Guide for Dharma MCP

Welcome! This guide is specifically for developers who know HTML, CSS, and JavaScript but are new to Ruby and Rails. 

## 🚀 Quick Start with DevContainer

### Prerequisites
- VS Code installed
- Docker Desktop running
- Dev Containers extension for VS Code

### Getting Started
1. **Clone the repository** (or open it in VS Code)
2. **Open in DevContainer**: 
   - Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
   - Type "Dev Containers: Reopen in Container"
   - Wait for container to build (first time takes ~5 minutes)

3. **Everything is automatically set up!** 🎉
   - Ruby 3.2.2 installed
   - MySQL database running
   - All gems installed
   - Sample data loaded
   - Helpful extensions installed

## 🏗 How This Compares to What You Know

### Coming from JavaScript/Node.js

| JavaScript | Ruby | Purpose |
|------------|------|---------|
| `npm install` | `bundle install` | Install dependencies |
| `package.json` | `Gemfile` | Dependency file |
| `node server.js` | `rails server` | Start server |
| `console.log()` | `puts` or `p` | Print to console |
| `const/let` | no declaration needed | Variables |
| `.js` files | `.rb` files | File extension |

### Coming from HTML/CSS
- **No views needed** - This is an API-only Rails app (like a REST API)
- **Routes** work like URL handlers (similar to Express.js routes)
- **Controllers** handle HTTP requests (like your API endpoints)
- **Models** represent database tables (think of them as structured data)

## 🎯 Ruby Basics for You

### Variables (No Declaration Needed!)
```ruby
# JavaScript: const name = "Dharma"
name = "Dharma"                 # String
price = 19.99                   # Number (Float)
count = 5                       # Number (Integer)  
active = true                   # Boolean
colors = ["red", "blue"]        # Array (like JS array)
product = { name: "Dye" }       # Hash (like JS object)
```

### Methods (Like Functions)
```ruby
# JavaScript: function getName() { return "Dharma"; }
def get_name
  "Dharma"  # Ruby returns last line automatically
end

# With parameters
# JavaScript: function add(a, b) { return a + b; }
def add(a, b)
  a + b
end
```

### Classes (Like ES6 Classes)
```ruby
# JavaScript: class Product { constructor(name) { this.name = name; } }
class Product
  def initialize(name)  # Like constructor
    @name = name        # Like this.name (@ means instance variable)
  end
  
  def display
    puts @name
  end
end

product = Product.new("Red Dye")
```

## 🛤 Rails Basics for You

### Project Structure (Like Express.js Structure)
```
app/
  controllers/     # Like your API route handlers
    mcp_controller.rb        # Handles /mcp requests
    products_controller.rb   # Handles /products requests
  models/         # Database models (like Mongoose schemas)
    product.rb              # Product model
config/
  routes.rb       # URL routing (like Express routes)
  database.yml    # Database config (like your DB connection)
db/
  migrate/        # Database schema changes (like migrations)
  seeds.rb        # Sample data (like your test data)
```

### Routes (Like Express Routes)
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Like: app.get('/mcp/tools/list', handler)
  get 'mcp/tools/list', to: 'mcp#tools_list'
  
  # Like: app.post('/mcp/tools/call', handler)  
  post 'mcp/tools/call', to: 'mcp#call_tool'
  
  # RESTful routes (creates all CRUD endpoints)
  resources :products  # Creates GET, POST, PUT, DELETE for /products
end
```

### Controllers (Like Route Handlers)
```ruby
# app/controllers/mcp_controller.rb
class McpController < ApplicationController
  # Like: app.get('/mcp/tools/list', (req, res) => { res.json(tools); })
  def tools_list
    tools = [{ name: "search_products", description: "..." }]
    render json: { tools: tools }  # Like res.json()
  end
  
  # Like: app.post('/mcp/tools/call', (req, res) => { ... })
  def call_tool
    tool_name = params[:name]      # Like req.body.name
    arguments = params[:arguments] # Like req.body.arguments
    
    # Handle the tool call
    render json: { result: "success" }
  end
end
```

### Models (Like Database Schemas)
```ruby
# app/models/product.rb
class Product < ApplicationRecord  # Like extending a base model
  # Relationships (like Mongoose populate)
  belongs_to :product_family    # Like foreign key
  has_many :variants           # Like one-to-many
  
  # Validations (like schema validation)
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end

# Usage (like your ORM)
products = Product.all                    # Like find()
product = Product.find(1)                # Like findById() 
cotton_products = Product.where(fiber_content: "cotton")  # Like find({...})
Product.create(name: "Red Dye", price: 3.95)  # Like create()
```

## 🗄 Database with Rails

### Migrations (Like Database Schema Changes)
```ruby
# db/migrate/20231201000000_create_products.rb
class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.timestamps  # Adds created_at, updated_at
    end
  end
end
```

### Commands You'll Use
```bash
# Like npm install
bundle install

# Database commands
rails db:create     # Create database
rails db:migrate    # Apply schema changes
rails db:seed       # Load sample data
rails db:reset      # Reset everything

# Server commands  
rails server        # Start server (like npm start)
rails console       # Interactive Ruby (like node REPL)

# Testing
rails test          # Run tests (like npm test)
```

## 🧪 Testing Your Code

### Use the Built-in HTTP Test File
The DevContainer creates `api_tests.http` - click on any request and press "Send Request":

```http
### Test Health Endpoint
GET http://localhost:3000/up

### List All MCP Tools  
GET http://localhost:3000/mcp/tools/list

### Search for Cotton Dyes
POST http://localhost:3000/mcp/tools/call
Content-Type: application/json

{
  "name": "search_products",
  "arguments": {
    "fiber_type": "cotton",
    "query": "dye"
  }
}
```

### Use Rails Console (Like Node REPL)
```bash
rails console
# or shorter:
rails c
```

```ruby
# In Rails console - try these:
Product.count                 # How many products?
Product.first                 # Get first product
Product.where(use_on: "cotton")  # Find cotton-compatible products
```

## 🔧 VS Code Features Set Up for You

### Extensions Installed
- **Ruby** - Syntax highlighting and IntelliSense
- **Rails Routes** - See all your routes
- **REST Client** - Test APIs with .http files
- **MySQL Client** - Browse database visually
- **GitLens** - Enhanced Git integration

### Keyboard Shortcuts
- `Ctrl+Shift+P` - Command palette
- `Ctrl+`` ` - Open terminal
- `F5` - Start debugging
- Click "▶" next to HTTP requests to test them

### VS Code Tasks (Press `Ctrl+Shift+P` → "Tasks: Run Task")
- **Start Rails Server** - Starts the web server
- **Rails Console** - Opens interactive Ruby
- **Run Tests** - Runs the test suite
- **Database Reset** - Resets the database

## 🎯 Your Mission: Understanding MCP Tools

The app provides "tools" that AI agents can use. Think of them like API endpoints that help customers with fiber arts:

```ruby
# In app/controllers/mcp_controller.rb
def search_products(args)
  # Like: async function searchProducts(args) {
  query = args['query']
  fiber_type = args['fiber_type']
  
  # Find products (like database.find())
  products = Product.where("name ILIKE ?", "%#{query}%")
  
  if fiber_type.present?
    products = products.where("use_on ILIKE ?", "%#{fiber_type}%") 
  end
  
  # Return JSON (like res.json())
  render json: { products: products }
end
```

## 🐛 Debugging Tips

### Add Breakpoints
```ruby
def my_method
  binding.break  # Stops here (like debugger; in JS)
  # Your code here
end
```

### Print Debug Info
```ruby
puts "Debug: #{variable}"     # Like console.log()
p variable                    # Shows detailed info
pp variable                   # Pretty print
```

### Check Logs
```bash
tail -f log/development.log   # Like watching console in browser
```

## 📚 Learning Path

1. **Start here** - Get comfortable with the DevContainer
2. **Try the HTTP tests** - See how the API works
3. **Explore Rails console** - Play with the data
4. **Read the existing controllers** - See how endpoints work
5. **Modify something small** - Add a simple feature
6. **Read the Ruby cheat sheet** - Reference for syntax

## 🆘 Getting Help

### Built-in Help
- Check `RUBY_CHEATSHEET.md` for quick reference
- Use Rails console to explore: `Product.methods` shows what you can do
- VS Code IntelliSense shows method suggestions

### When Things Go Wrong
```bash
# Server won't start?
bundle install              # Reinstall gems

# Database errors?
rails db:reset             # Reset database

# Weird errors?
docker system prune -af    # Clean Docker (then rebuild container)
```

### Ruby Documentation
- [Ruby in 20 Minutes](https://www.ruby-lang.org/en/documentation/quickstart/) - Official tutorial
- [Rails Guides](https://guides.rubyonrails.org/) - Comprehensive Rails docs
- [Ruby Docs](https://ruby-doc.org/) - Method documentation

## 🎉 You're Ready!

The DevContainer sets up everything automatically. Just:
1. Open in DevContainer
2. Wait for setup to complete
3. Press `Ctrl+Shift+P` → "Tasks: Run Task" → "Start Rails Server"  
4. Visit http://localhost:3000/up to see it working!

Welcome to Ruby and Rails! 🚀