#!/bin/bash

# MCP Server Rails Model Scaffolds
# This script creates all the necessary models for the MCP server

echo "Creating Rails models for MCP server..."

# CraftInstructionsPage - for craft tutorial content
rails generate scaffold CraftInstructionsPage title:string content:text difficulty_level:string estimated_time:integer materials_needed:text steps:text images:text --no-views

# ProductFamily - product groupings
rails generate scaffold ProductFamily name:string description:text slug:string display_order:integer active:boolean --no-views

# ProductCategory - product categorization
rails generate scaffold ProductCategory name:string description:text slug:string parent_category:references display_order:integer active:boolean --no-views

# Product - main product model with fiber arts specifics
rails generate scaffold Product name:string description:text price:decimal sku:string weight:decimal dimensions:string availability:boolean product_family:references product_category:references available_colors:text available_sizes:text fiber_content:string weight_category:string yardage:integer care_instructions:text skill_level_required:string compatible_techniques:text recommended_for:text use_on:text --no-views

# ProductVariantList - product variants with color and size details
rails generate scaffold ProductVariantList product:references variant_type:string variant_value:string price_modifier:decimal sku_suffix:string available:boolean color_name:string color_hex:string size_label:string inventory_count:integer --no-views

# ProductRecommendation - for "customers also bought" suggestions
rails generate scaffold ProductRecommendation primary_product:references recommended_product:references recommendation_type:string confidence_score:decimal display_order:integer active:boolean --no-views

# TechniqueGuide - how-to information for fiber arts
rails generate scaffold TechniqueGuide title:string technique_type:string difficulty_level:string description:text instructions:text tools_needed:text time_estimate:integer video_url:string images:text active:boolean --no-views

# ProjectIdea - linking products to specific project types
rails generate scaffold ProjectIdea title:string description:text difficulty_level:string project_type:string estimated_time:integer finished_size:string instructions:text images:text active:boolean --no-views

# ProjectProduct - many-to-many between projects and products
rails generate scaffold ProjectProduct project_idea:references product:references quantity_needed:decimal notes:string --no-views

# FeaturedArtistPage - artist showcase content
rails generate scaffold FeaturedArtistPage artist_name:string bio:text featured_image:string portfolio_images:text social_links:text featured_until:datetime active:boolean --no-views

# FrequentlyAskedQuestion - FAQ content
rails generate scaffold FrequentlyAskedQuestion question:string answer:text category:string display_order:integer active:boolean --no-views

# SupportArticle - help/support documentation
rails generate scaffold SupportArticle title:string content:text category:string tags:string helpful_count:integer view_count:integer published:boolean --no-views

# AgentGuidance - contextual instructions for MCP agents
rails generate scaffold AgentGuidance context_type:string category:string conditions:text guidance_text:text suggested_actions:text priority:integer active:boolean --no-views

echo "Model scaffolding complete!"
echo "Generated models:"
echo "- Core: Product, ProductFamily, ProductCategory, ProductVariantList"
echo "- Content: CraftInstructionsPage, FeaturedArtistPage, SupportArticle, FrequentlyAskedQuestion"  
echo "- Recommendations: ProductRecommendation, TechniqueGuide, ProjectIdea, ProjectProduct"
echo "- Agent Support: AgentGuidance"
echo ""
echo "Next steps:"
echo "1. Run 'rails db:migrate' to create the database tables"
echo "2. Configure MCP endpoints in routes.rb"
echo "3. Set up model associations and validations"
echo "4. Add model validations for fiber arts specific fields"
echo "5. Consider adding indexes for common query patterns"