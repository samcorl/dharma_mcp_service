# Dharma Fiber Arts MCP Server

A simple Ruby-based MCP (Model Context Protocol) server for managing fiber arts dye kits and product compatibility.

## Requirements

- Ruby 2.0.0p648 (2015-12-16) [x86_64-linux]
- MySQL 8.0+
- Apache 2.2.34 (Unix)

## Installation

### 1. Install Ruby Dependencies

```bash
# Install bundler (if not already installed)
gem install bundler

# Install project dependencies
bundle install
```

If bundle is not available, install gems manually:
```bash
gem install mysql2 -v '~> 0.3.16'
gem install json -v '~> 1.8'
gem install sinatra -v '~> 1.4'
gem install thin -v '~> 1.6'
```

### 2. Database Setup

Set up your MySQL database with the required environment variables:

```bash
export DB_HOST=localhost
export DB_NAME=dharma_development
export DB_USER=dharma_user
export DB_PASS=dharma_password
export MCP_PORT=8080
```

Or create a `.env` file (not included in this basic implementation):
```
DB_HOST=localhost
DB_NAME=dharma_development
DB_USER=dharma_user
DB_PASS=dharma_password
MCP_PORT=8080
```

### 3. Apache Configuration

#### Add MCP proxy configuration to Apache:

```bash
# Copy the Apache configuration
sudo cp apache_mcp.conf /etc/httpd/conf.d/mcp.conf

# Or add the contents to your main httpd.conf
sudo cat apache_mcp.conf >> /etc/httpd/conf/httpd.conf
```

#### Restart Apache:
```bash
sudo service httpd restart
# or
sudo apachectl restart
```

### 4. Start the MCP Server

```bash
# Start the Ruby server
ruby mcp_server.rb
```

Or run in background:
```bash
nohup ruby mcp_server.rb > mcp_server.log 2>&1 &
```

## Usage

The server will be available at: `http://your-domain.com/mcp`

### Test the server:

```bash
# Test tools/list
curl -X POST http://localhost/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'

# Test get_blank_families
curl -X POST http://localhost/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"get_blank_families","arguments":{"material_type":"cotton"}},"id":2}'
```

## Available MCP Tools

1. **get_blank_families** - Get available blank product families
2. **get_products_by_family** - Get specific products within a family
3. **get_compatible_dyes** - Find compatible dyes for materials
4. **find_instructions** - Search for dyeing instructions
5. **add_to_kit** - Add products to current kit session
6. **get_kit_summary** - Get kit contents and cart URL
7. **clear_kit** - Empty the current kit

## Database Schema

Required tables in your MySQL database:

```sql
-- Products table
CREATE TABLE things (
    objid VARCHAR(50) PRIMARY KEY,
    objtype VARCHAR(20),
    name VARCHAR(255),
    subtitle TEXT,
    discountgroup CHAR(1),
    price DECIMAL(10,2),
    instock TINYINT(1)
);

-- Extended properties table  
CREATE TABLE extraprop_things (
    objid VARCHAR(50),
    fieldname VARCHAR(100),
    fieldvalue TEXT,
    INDEX(objid)
);
```

## Configuration

Environment variables:
- `DB_HOST` - MySQL host (default: localhost)
- `DB_NAME` - Database name (default: dharma_development) 
- `DB_USER` - Database username (default: dharma_user)
- `DB_PASS` - Database password (default: dharma_password)
- `MCP_PORT` - Server port (default: 8080)

## Troubleshooting

### Server won't start:
- Check Ruby version: `ruby --version`
- Verify gems are installed: `bundle list`
- Check database connection with provided credentials

### Apache proxy errors:
- Verify mod_proxy and mod_proxy_http are loaded
- Check Apache error logs: `tail -f /var/log/httpd/error_log`
- Ensure MCP server is running on port 8080

### Database connection issues:
- Verify MySQL is running
- Test database connection manually
- Check firewall settings for MySQL port (3306)

## Logging

- Apache access logs: `/var/log/httpd/mcp_access.log`
- Apache error logs: `/var/log/httpd/mcp_error.log`
- MCP server logs: Check stdout/stderr or `mcp_server.log`

## Security Notes

- The server uses basic session management suitable for development
- For production, implement proper authentication and session storage
- Adjust CORS settings in Apache configuration as needed
- Consider using HTTPS in production environments