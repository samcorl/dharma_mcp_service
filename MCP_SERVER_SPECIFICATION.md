# Dharma Fiber Arts MCP Server Specification

## Overview
MCP (Model Context Protocol) server for a fiber arts business that helps customers create custom dye kits. The server provides tools to browse products, find compatible materials, and generate shopping carts for dharmatrading.com.

## Database Schema

### Primary Tables
- **`things`**: Main product catalog
  - `objid` (primary key)
  - `objtype`: Product categorization
    - `'45000-A'` = Products (blanks, dyes, paints)
    - `'47001-A'` = Instructional content/info pages
    - `'47005-A'` = Product families
  - `name`: Product name
  - `subtitle`: Product description (contains compatibility info)
  - `discountgroup`: Material type indicator
    - `'C'` = Cotton products
    - `'S'` = Silk products
  - `price`: Product price
  - `instock`: Inventory status

- **`extraprop_things`**: Extended product properties
  - `objid` (foreign key to things)
  - `fieldname`: Property name
  - `fieldvalue`: Property value

## Business Logic

### Material Compatibility
- Products are cotton (`discountgroup: 'C'`) or silk (`discountgroup: 'S'`)
- Dye compatibility is determined by parsing `subtitle` field for "USE ON:" sections
- Example: "USE ON: cotton, silk, wool" indicates multi-material compatibility

### Product Categories
- **Blanks**: Cotton/silk items ready for dyeing (shirts, scarves, etc.)
- **Dyes/Paints**: Colorants with material-specific compatibility
- **Instructions**: How-to content for dyeing techniques
- **Product Families**: Groupings of related blank products

### Kit Creation Workflow
1. **Choose Material Type**: cotton or silk
2. **Select Blank Families**: Available blank product groups for chosen material
3. **Choose Compatible Dyes**: Dyes/paints that work with selected material
4. **Find Instructions**: Relevant dyeing tutorials
5. **Generate Cart URL**: dharmatrading.com cart link + download materials list

## MCP Tools Specification

### Tool 1: `get_blank_families`
**Description**: Get available blank product families for cotton or silk items

**Parameters**:
- `material_type` (optional): `"cotton"` | `"silk"` | `null` (for all)

**Returns**:
```json
{
  "families": [
    {
      "objid": "family_id",
      "name": "T-Shirts",
      "material_type": "cotton",
      "product_count": 15
    }
  ]
}
```

**Database Query Logic**:
```sql
SELECT * FROM things 
WHERE objtype = '47005-A' 
AND (discountgroup = 'C' OR discountgroup = 'S')
```

### Tool 2: `get_products_by_family`
**Description**: Get specific products within a blank family

**Parameters**:
- `family_id` (required): Product family objid
- `material_type` (optional): Filter by material

**Returns**:
```json
{
  "products": [
    {
      "objid": "product_id",
      "name": "Adult Cotton T-Shirt",
      "price": 8.95,
      "material_type": "cotton",
      "instock": true
    }
  ]
}
```

### Tool 3: `get_compatible_dyes`
**Description**: Find dyes and paints compatible with specified material types

**Parameters**:
- `material_types` (required): Array of `["cotton", "silk"]`

**Returns**:
```json
{
  "dyes": [
    {
      "objid": "dye_id", 
      "name": "Procion MX Dye - Red",
      "price": 3.25,
      "compatible_materials": ["cotton", "silk"],
      "instock": true
    }
  ]
}
```

**Logic**: Parse `subtitle` field for "USE ON:" patterns and match against requested materials

### Tool 4: `find_instructions`
**Description**: Search for dyeing instructions and tutorials

**Parameters**:
- `search_terms` (optional): Keywords to search for
- `material_type` (optional): Filter by material compatibility

**Returns**:
```json
{
  "instructions": [
    {
      "objid": "instruction_id",
      "name": "Basic Tie-Dye Techniques",
      "subtitle": "Step-by-step cotton dyeing guide",
      "materials": ["cotton"]
    }
  ]
}
```

### Tool 5: `add_to_kit`
**Description**: Add products to current kit session

**Parameters**:
- `product_id` (required): Product objid to add
- `quantity` (optional): Number of items (default: 1)

**Returns**:
```json
{
  "success": true,
  "kit_total_items": 5,
  "message": "Added to kit"
}
```

### Tool 6: `get_kit_summary`
**Description**: Get current kit contents and generate cart URL

**Parameters**: None

**Returns**:
```json
{
  "kit": {
    "items": [
      {
        "objid": "product_id",
        "name": "Cotton T-Shirt",
        "quantity": 2,
        "unit_price": 8.95,
        "total_price": 17.90
      }
    ],
    "total_price": 45.75,
    "item_count": 8
  },
  "cart_url": "https://www.dharmatrading.com/add_to_cart?items=product1:2,product2:1",
  "materials_list_pdf": "base64_encoded_pdf_data"
}
```

### Tool 7: `clear_kit`
**Description**: Empty the current kit

**Parameters**: None

**Returns**:
```json
{
  "success": true,
  "message": "Kit cleared"
}
```

## Technical Requirements

### Database Connection
- **Type**: MySQL 8.0+
- **Connection**: Standard MySQL client
- **Tables**: `things`, `extraprop_things`
- **Encoding**: UTF-8

### MCP Protocol Implementation
- **Transport**: TCP socket server (port 8080)
- **Protocol**: JSON-RPC 2.0
- **Required Methods**:
  - `tools/list`: Return available tools
  - `tools/call`: Execute specific tool with parameters

### Session Management
- Maintain kit state per client connection
- In-memory storage acceptable for MVP
- Session expires on disconnect

### External Integration
- **Cart URLs**: Generate dharmatrading.com compatible cart links
- **PDF Generation**: Create materials list summary (optional)

### Environment Variables
```bash
DB_HOST=localhost
DB_NAME=dharma_development  
DB_USER=dharma_user
DB_PASS=dharma_password
MCP_PORT=8080
```

## Error Handling
- Database connection failures: Continue with limited functionality
- Invalid parameters: Return JSON-RPC error response
- Product not found: Return empty arrays, not errors
- Kit operations: Graceful degradation if session lost

## Sample Database Data Structure
```sql
-- Product example
INSERT INTO things (objid, objtype, name, subtitle, discountgroup, price, instock) 
VALUES ('12345', '45000-A', 'Adult Cotton T-Shirt', 'Premium cotton blank for dyeing', 'C', 8.95, 1);

-- Dye example  
INSERT INTO things (objid, objtype, name, subtitle, price, instock)
VALUES ('67890', '45000-A', 'Procion MX Dye', 'USE ON: cotton, linen, hemp. Professional grade dye', 3.25, 1);

-- Family example
INSERT INTO things (objid, objtype, name, discountgroup) 
VALUES ('FAM001', '47005-A', 'T-Shirts & Tops', 'C');
```

This specification provides everything needed to recreate the MCP server in Node.js with identical functionality and tool interfaces.