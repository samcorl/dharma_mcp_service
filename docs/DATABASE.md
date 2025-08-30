# Database Schema Documentation

This document describes the database structure for the Dharma MCP Service.

## Overview

The database uses MySQL 8.0 with utf8mb4 encoding to support full Unicode characters. The schema is designed around fiber arts products, recommendations, and agent guidance.

## Core Product Models

### products
Main product catalog with fiber arts specific attributes.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| name | varchar(255) | Product name |
| description | text | Detailed description |
| price | decimal(10,2) | Product price |
| sku | varchar(255) | Stock keeping unit |
| weight | decimal(8,2) | Physical weight |
| dimensions | varchar(255) | Physical dimensions |
| availability | boolean | In stock status |
| product_family_id | bigint | Foreign key to product_families |
| product_category_id | bigint | Foreign key to product_categories |
| available_colors | text | JSON array of color options |
| available_sizes | text | JSON array of size options |
| fiber_content | varchar(255) | Fiber composition |
| weight_category | varchar(255) | Yarn weight (DK, worsted, etc.) |
| yardage | integer | Yards per unit (for yarns) |
| care_instructions | text | Care and maintenance |
| skill_level_required | varchar(255) | Required skill level |
| compatible_techniques | text | Compatible crafting techniques |
| recommended_for | text | Recommended project types |
| use_on | text | **Compatible fiber types** |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_products_sku (sku)
INDEX idx_products_family (product_family_id)
INDEX idx_products_category (product_category_id) 
INDEX idx_products_availability (availability)
INDEX idx_products_skill_level (skill_level_required)
```

### product_families
Product groupings (e.g., "Cotton Fabrics", "Wool Yarns").

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| name | varchar(255) | Family name |
| description | text | Family description |
| slug | varchar(255) | URL-friendly identifier |
| display_order | integer | Sort order |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
UNIQUE INDEX idx_product_families_slug (slug)
INDEX idx_product_families_active (active)
```

### product_categories  
Product categorization (e.g., "Dyes", "Yarns", "Tools").

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| name | varchar(255) | Category name |
| description | text | Category description |
| slug | varchar(255) | URL-friendly identifier |
| parent_category_id | bigint | Self-reference for hierarchy |
| display_order | integer | Sort order |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
UNIQUE INDEX idx_product_categories_slug (slug)
INDEX idx_product_categories_parent (parent_category_id)
INDEX idx_product_categories_active (active)
```

### product_variant_lists
Color and size variants with inventory tracking.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| product_id | bigint | Foreign key to products |
| variant_type | varchar(255) | Type (color, size, etc.) |
| variant_value | varchar(255) | Variant value |
| price_modifier | decimal(8,2) | Price adjustment |
| sku_suffix | varchar(255) | SKU extension |
| available | boolean | Availability status |
| color_name | varchar(255) | Display color name |
| color_hex | varchar(255) | Hex color code |
| size_label | varchar(255) | Size display label |
| inventory_count | integer | Current stock count |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_product_variants_product (product_id)
INDEX idx_product_variants_available (available)
INDEX idx_product_variants_type (variant_type)
```

## Content Models

### craft_instructions_pages
Tutorial and craft instruction content.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| title | varchar(255) | Instruction title |
| content | text | Full instruction content |
| difficulty_level | varchar(255) | Difficulty rating |
| estimated_time | integer | Time in minutes |
| materials_needed | text | Required materials |
| steps | text | Step-by-step instructions |
| images | text | JSON array of image URLs |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

### technique_guides
Step-by-step technique instructions.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| title | varchar(255) | Guide title |
| technique_type | varchar(255) | Technique category |
| difficulty_level | varchar(255) | Skill level required |
| description | text | Guide overview |
| instructions | text | Detailed instructions |
| tools_needed | text | Required tools |
| time_estimate | integer | Estimated time in minutes |
| video_url | varchar(255) | Optional video link |
| images | text | JSON array of image URLs |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_technique_guides_type (technique_type)
INDEX idx_technique_guides_difficulty (difficulty_level)
INDEX idx_technique_guides_active (active)
```

### project_ideas
Complete project suggestions with supply lists.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| title | varchar(255) | Project title |
| description | text | Project description |
| difficulty_level | varchar(255) | Required skill level |
| project_type | varchar(255) | Project category |
| estimated_time | integer | Time to complete (minutes) |
| finished_size | varchar(255) | Final dimensions |
| instructions | text | Project instructions |
| images | text | JSON array of image URLs |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_project_ideas_type (project_type)
INDEX idx_project_ideas_difficulty (difficulty_level)
INDEX idx_project_ideas_active (active)
```

### project_products
Many-to-many linking projects to required products.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| project_idea_id | bigint | Foreign key to project_ideas |
| product_id | bigint | Foreign key to products |
| quantity_needed | decimal(8,2) | Required amount |
| notes | varchar(255) | Special notes |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_project_products_project (project_idea_id)
INDEX idx_project_products_product (product_id)
UNIQUE INDEX idx_project_products_unique (project_idea_id, product_id)
```

## Recommendation System

### product_recommendations
"Customers also bought" and related product suggestions.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| primary_product_id | bigint | Foreign key to products (source) |
| recommended_product_id | bigint | Foreign key to products (target) |
| recommendation_type | varchar(255) | Type of recommendation |
| confidence_score | decimal(4,2) | Confidence (0.0-1.0) |
| display_order | integer | Sort order |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_product_recs_primary (primary_product_id)
INDEX idx_product_recs_recommended (recommended_product_id)
INDEX idx_product_recs_type (recommendation_type)
INDEX idx_product_recs_active (active)
```

## Agent Support Models

### agent_guidances
Contextual instructions for MCP agents.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| context_type | varchar(255) | Context trigger |
| category | varchar(255) | Content category |
| conditions | text | JSON matching conditions |
| guidance_text | text | Instruction text |
| suggested_actions | text | JSON array of actions |
| priority | integer | Priority order |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Context Types:**
- `no_results_found` - When searches return empty
- `too_many_results` - When searches return >50 items  
- `compatibility_check` - Fiber/product compatibility
- `project_recommendation` - Project-based guidance
- `beginner_guidance` - New user assistance

**Key Indexes:**
```sql
INDEX idx_agent_guidance_context (context_type)
INDEX idx_agent_guidance_category (category)
INDEX idx_agent_guidance_active (active)
INDEX idx_agent_guidance_priority (priority)
```

## Support Content Models

### frequently_asked_questions
FAQ content for customer support.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| question | varchar(255) | FAQ question |
| answer | text | FAQ answer |
| category | varchar(255) | Content category |
| display_order | integer | Sort order |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

### support_articles
Help articles and documentation.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| title | varchar(255) | Article title |
| content | text | Article content |
| category | varchar(255) | Content category |
| tags | varchar(255) | Comma-separated tags |
| helpful_count | integer | Helpfulness votes |
| view_count | integer | View counter |
| published | boolean | Publication status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

**Key Indexes:**
```sql
INDEX idx_support_articles_category (category)
INDEX idx_support_articles_published (published)
INDEX idx_support_articles_helpful (helpful_count)
```

### featured_artist_pages
Artist showcase content.

| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| artist_name | varchar(255) | Artist name |
| bio | text | Artist biography |
| featured_image | varchar(255) | Main image URL |
| portfolio_images | text | JSON array of image URLs |
| social_links | text | JSON object of social media |
| featured_until | datetime | Feature expiration |
| active | boolean | Active status |
| created_at | timestamp | Record creation |
| updated_at | timestamp | Last modification |

## Relationships

```
product_families (1) ──── (many) products
product_categories (1) ──── (many) products
products (1) ──── (many) product_variant_lists

project_ideas (many) ──── (many) products (via project_products)

products (1 as primary) ──── (many) product_recommendations
products (1 as recommended) ──── (many) product_recommendations

product_categories (1 as parent) ──── (many) product_categories (as children)
```

## Query Patterns

### Common Queries

**Find products compatible with cotton:**
```sql
SELECT * FROM products 
WHERE use_on LIKE '%cotton%' 
AND availability = true;
```

**Get all variants for a product:**
```sql
SELECT * FROM product_variant_lists 
WHERE product_id = ? 
AND available = true
ORDER BY variant_type, variant_value;
```

**Find beginner-friendly projects:**
```sql
SELECT pi.*, pp.product_id, pp.quantity_needed, p.name
FROM project_ideas pi
JOIN project_products pp ON pi.id = pp.project_idea_id
JOIN products p ON pp.product_id = p.id
WHERE pi.difficulty_level = 'beginner'
AND pi.active = true;
```

**Get recommendations for a product:**
```sql
SELECT pr.*, p.name, p.price, p.use_on
FROM product_recommendations pr
JOIN products p ON pr.recommended_product_id = p.id  
WHERE pr.primary_product_id = ?
AND pr.active = true
ORDER BY pr.display_order, pr.confidence_score DESC;
```

## Performance Considerations

### Indexes
All frequently queried columns have appropriate indexes. Full-text search would benefit from:

```sql
ALTER TABLE products ADD FULLTEXT(name, description);
ALTER TABLE support_articles ADD FULLTEXT(title, content);
```

### Query Optimization
- Use `includes()` in Rails to avoid N+1 queries
- Limit result sets with pagination
- Cache frequent queries (Redis recommended)
- Use database views for complex reporting

### Scaling Considerations
- Read replicas for query scaling
- Partitioning for large tables (products, recommendations)
- Archive old data (support_articles view counts)
- Consider NoSQL for flexibility (product attributes)

## Backup Strategy

### Daily Backups
```bash
mysqldump -u root -p dharma_mcp_production > backup_$(date +%Y%m%d).sql
```

### Point-in-time Recovery
Enable binary logging for point-in-time recovery:
```sql
SET GLOBAL log_bin = ON;
SET GLOBAL binlog_format = 'ROW';
```

## Migration Notes

### JSON Columns
Several columns store JSON data:
- `products.available_colors` - Array of color names
- `products.available_sizes` - Array of size options  
- `agent_guidances.conditions` - Matching conditions
- `agent_guidances.suggested_actions` - Action array

### Charset
All tables use `utf8mb4` to support emoji and full Unicode range.

### Foreign Keys
All foreign key constraints are enforced at the database level for data integrity.