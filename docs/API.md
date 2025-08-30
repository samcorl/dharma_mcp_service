# MCP Tools API Documentation

The Dharma MCP Service provides tools for fiber arts agents to help customers with product recommendations, compatibility checking, and project guidance.

## Base URL
```
http://your-server:3000/mcp
```

## Endpoints

### List Available Tools
```http
GET /mcp/tools/list
```

Returns all available MCP tools with their schemas.

### Call Tool
```http
POST /mcp/tools/call
Content-Type: application/json

{
  "name": "tool_name",
  "arguments": {
    "param1": "value1"
  }
}
```

## Available Tools

### 1. search_products
Search products by various criteria.

**Parameters:**
- `query` (string): Search query
- `fiber_type` (string): Filter by fiber type (cotton, wool, silk, etc.)
- `color` (string): Filter by color
- `technique` (string): Filter by compatible technique
- `skill_level` (string): Filter by skill level required
- `price_range` (string): Price range filter

**Example:**
```json
{
  "name": "search_products",
  "arguments": {
    "query": "dye",
    "fiber_type": "cotton",
    "skill_level": "beginner"
  }
}
```

**Response:**
```json
{
  "products": [
    {
      "id": 1,
      "name": "Dharma Fiber Reactive Dye - Red",
      "description": "Professional grade fiber reactive dye...",
      "price": 3.95,
      "fiber_content": "Dye powder",
      "use_on": "cotton, rayon, linen, hemp, bamboo",
      "available_colors": ["Red", "Crimson", "Scarlet"],
      "skill_level_required": "beginner",
      "compatible_techniques": "dyeing, tie-dye, batik"
    }
  ]
}
```

### 2. get_product_details
Get detailed information about a specific product.

**Parameters:**
- `product_id` (integer, required): Product ID

**Example:**
```json
{
  "name": "get_product_details",
  "arguments": {
    "product_id": 1
  }
}
```

### 3. check_compatibility
Check if a product is compatible with specified fiber type.

**Parameters:**
- `product_id` (integer, required): Product ID
- `fiber_type` (string, required): Fiber type to check compatibility

**Example:**
```json
{
  "name": "check_compatibility",
  "arguments": {
    "product_id": 1,
    "fiber_type": "cotton"
  }
}
```

**Response:**
```json
{
  "compatible": true,
  "product_name": "Dharma Fiber Reactive Dye - Red",
  "fiber_type": "cotton",
  "supported_fibers": ["cotton", "rayon", "linen", "hemp", "bamboo"]
}
```

### 4. get_product_recommendations
Get product recommendations based on a specific product.

**Parameters:**
- `product_id` (integer, required): Product ID
- `recommendation_type` (string): Type of recommendation

**Example:**
```json
{
  "name": "get_product_recommendations",
  "arguments": {
    "product_id": 1,
    "recommendation_type": "complementary"
  }
}
```

### 5. suggest_for_project
Get complete product suggestions for a specific project type.

**Parameters:**
- `project_type` (string, required): Type of project (scarf, blanket, etc.)
- `fiber_type` (string): Preferred fiber type
- `skill_level` (string): Crafter's skill level

**Example:**
```json
{
  "name": "suggest_for_project",
  "arguments": {
    "project_type": "scarf",
    "fiber_type": "cotton",
    "skill_level": "beginner"
  }
}
```

### 6. get_technique_guide
Get step-by-step technique guide.

**Parameters:**
- `technique_name` (string, required): Name of technique
- `difficulty_level` (string): Filter by difficulty level

**Example:**
```json
{
  "name": "get_technique_guide",
  "arguments": {
    "technique_name": "dyeing",
    "difficulty_level": "beginner"
  }
}
```

### 7. get_agent_guidance
Get contextual guidance for agents when stuck or need direction.

**Parameters:**
- `context_type` (string, required): Context type (no_results, too_many_results, etc.)
- `category` (string): Category (products, techniques, etc.)
- `conditions` (object): Conditions object for matching guidance

**Example:**
```json
{
  "name": "get_agent_guidance",
  "arguments": {
    "context_type": "no_results_found",
    "category": "products"
  }
}
```

### 8. search_support
Search FAQ answers and support articles.

**Parameters:**
- `query` (string, required): Search query
- `category` (string): Filter by category

**Example:**
```json
{
  "name": "search_support",
  "arguments": {
    "query": "fiber reactive dye",
    "category": "dyeing"
  }
}
```

**Response:**
```json
{
  "faqs": [
    {
      "id": 1,
      "question": "What's the difference between fiber reactive dyes and other dyes?",
      "answer": "Fiber reactive dyes chemically bond with cellulose fibers...",
      "category": "dyeing"
    }
  ],
  "articles": [
    {
      "id": 1,
      "title": "Choosing the Right Dye for Your Fiber",
      "content": "Different fibers require different types of dyes...",
      "category": "dyeing",
      "helpful_count": 25
    }
  ]
}
```

## Error Responses

When an error occurs, the API returns:

```json
{
  "error": "Error message describing what went wrong"
}
```

Common error scenarios:
- Invalid tool name
- Missing required parameters
- Product not found
- Database connection issues

## Agent Guidance System

The API includes an intelligent guidance system that provides contextual help:

- **No Results**: When searches return empty, provides alternative search suggestions
- **Too Many Results**: When searches return >50 results, suggests filters to narrow down
- **Compatibility Issues**: When products aren't compatible, suggests alternatives
- **Beginner Guidance**: Context-aware help for new fiber artists

This guidance is automatically included in responses when relevant, or can be explicitly requested via `get_agent_guidance`.