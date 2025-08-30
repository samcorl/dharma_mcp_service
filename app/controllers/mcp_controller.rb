class McpController < ApplicationController
  # MCP server endpoints for fiber arts agent tools
  
  def tools_list
    tools = [
      {
        name: "search_products",
        description: "Search products by query, fiber type, color, technique, skill level",
        inputSchema: {
          type: "object",
          properties: {
            query: { type: "string", description: "Search query" },
            fiber_type: { type: "string", description: "Filter by fiber type (cotton, wool, silk, etc.)" },
            color: { type: "string", description: "Filter by color" },
            technique: { type: "string", description: "Filter by compatible technique" },
            skill_level: { type: "string", description: "Filter by skill level required" },
            price_range: { type: "string", description: "Price range filter" }
          }
        }
      },
      {
        name: "get_product_details",
        description: "Get detailed information about a specific product",
        inputSchema: {
          type: "object",
          properties: {
            product_id: { type: "integer", description: "Product ID" }
          },
          required: ["product_id"]
        }
      },
      {
        name: "check_compatibility",
        description: "Check if a product is compatible with specified fiber type",
        inputSchema: {
          type: "object",
          properties: {
            product_id: { type: "integer", description: "Product ID" },
            fiber_type: { type: "string", description: "Fiber type to check compatibility" }
          },
          required: ["product_id", "fiber_type"]
        }
      },
      {
        name: "get_product_recommendations",
        description: "Get product recommendations based on a specific product",
        inputSchema: {
          type: "object",
          properties: {
            product_id: { type: "integer", description: "Product ID" },
            recommendation_type: { type: "string", description: "Type of recommendation" }
          },
          required: ["product_id"]
        }
      },
      {
        name: "suggest_for_project",
        description: "Get complete product suggestions for a specific project type",
        inputSchema: {
          type: "object",
          properties: {
            project_type: { type: "string", description: "Type of project (scarf, blanket, etc.)" },
            fiber_type: { type: "string", description: "Preferred fiber type" },
            skill_level: { type: "string", description: "Crafter's skill level" }
          },
          required: ["project_type"]
        }
      },
      {
        name: "get_technique_guide",
        description: "Get step-by-step technique guide",
        inputSchema: {
          type: "object",
          properties: {
            technique_name: { type: "string", description: "Name of technique" },
            difficulty_level: { type: "string", description: "Filter by difficulty level" }
          },
          required: ["technique_name"]
        }
      },
      {
        name: "get_agent_guidance",
        description: "Get contextual guidance for agents when stuck or need direction",
        inputSchema: {
          type: "object",
          properties: {
            context_type: { type: "string", description: "Context type (no_results, too_many_results, etc.)" },
            category: { type: "string", description: "Category (products, techniques, etc.)" },
            conditions: { type: "object", description: "Conditions object for matching guidance" }
          },
          required: ["context_type"]
        }
      },
      {
        name: "search_support",
        description: "Search FAQ answers and support articles",
        inputSchema: {
          type: "object",
          properties: {
            query: { type: "string", description: "Search query" },
            category: { type: "string", description: "Filter by category" }
          },
          required: ["query"]
        }
      }
    ]
    
    render json: { tools: tools }
  end

  def call_tool
    tool_name = params[:name]
    arguments = params[:arguments] || {}
    
    case tool_name
    when 'search_products'
      search_products(arguments)
    when 'get_product_details'
      get_product_details(arguments)
    when 'check_compatibility'
      check_compatibility(arguments)
    when 'get_product_recommendations'
      get_product_recommendations(arguments)
    when 'suggest_for_project'
      suggest_for_project(arguments)
    when 'get_technique_guide'
      get_technique_guide(arguments)
    when 'get_agent_guidance'
      get_agent_guidance(arguments)
    when 'search_support'
      search_support(arguments)
    else
      render json: { error: "Unknown tool: #{tool_name}" }, status: 400
    end
  rescue => e
    render json: { error: "Internal error: #{e.message}" }, status: 500
  end

  private

  def search_products(args)
    products = Product.includes(:product_family, :product_category, :product_variant_lists).all
    
    # Apply filters
    if args['query'].present?
      products = products.where("name ILIKE ? OR description ILIKE ?", "%#{args['query']}%", "%#{args['query']}%")
    end
    
    if args['fiber_type'].present?
      products = products.where("use_on ILIKE ? OR fiber_content ILIKE ?", "%#{args['fiber_type']}%", "%#{args['fiber_type']}%")
    end
    
    if args['technique'].present?
      products = products.where("compatible_techniques ILIKE ?", "%#{args['technique']}%")
    end
    
    if args['skill_level'].present?
      products = products.where(skill_level_required: args['skill_level'])
    end
    
    # Format results
    results = products.limit(50).map do |product|
      {
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        fiber_content: product.fiber_content,
        use_on: product.use_on,
        available_colors: JSON.parse(product.available_colors || '[]'),
        available_sizes: JSON.parse(product.available_sizes || '[]'),
        skill_level_required: product.skill_level_required,
        compatible_techniques: product.compatible_techniques
      }
    end
    
    # Get agent guidance if no results
    if results.empty?
      guidance = get_contextual_guidance('no_results_found', 'products', args)
      render json: { products: results, guidance: guidance }
    elsif results.length >= 50
      guidance = get_contextual_guidance('too_many_results', 'products', args)
      render json: { products: results, guidance: guidance }
    else
      render json: { products: results }
    end
  end

  def get_product_details(args)
    product = Product.includes(:product_family, :product_category, :product_variant_lists).find(args['product_id'])
    
    result = {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      sku: product.sku,
      fiber_content: product.fiber_content,
      use_on: product.use_on,
      available_colors: JSON.parse(product.available_colors || '[]'),
      available_sizes: JSON.parse(product.available_sizes || '[]'),
      weight_category: product.weight_category,
      yardage: product.yardage,
      care_instructions: product.care_instructions,
      skill_level_required: product.skill_level_required,
      compatible_techniques: product.compatible_techniques,
      recommended_for: product.recommended_for,
      family: product.product_family&.name,
      category: product.product_category&.name,
      variants: product.product_variant_lists.map do |variant|
        {
          id: variant.id,
          type: variant.variant_type,
          value: variant.variant_value,
          color_name: variant.color_name,
          color_hex: variant.color_hex,
          size_label: variant.size_label,
          price_modifier: variant.price_modifier,
          available: variant.available,
          inventory_count: variant.inventory_count
        }
      end
    }
    
    render json: { product: result }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: 404
  end

  def check_compatibility(args)
    product = Product.find(args['product_id'])
    fiber_type = args['fiber_type'].downcase
    
    # Check use_on field
    use_on_fibers = (product.use_on || '').downcase.split(/[,\s]+/).map(&:strip)
    compatible = use_on_fibers.include?(fiber_type)
    
    result = {
      compatible: compatible,
      product_name: product.name,
      fiber_type: fiber_type,
      supported_fibers: use_on_fibers
    }
    
    unless compatible
      # Get alternative recommendations
      alternatives = Product.where("use_on ILIKE ?", "%#{fiber_type}%").limit(3)
      result[:alternatives] = alternatives.map { |p| { id: p.id, name: p.name, use_on: p.use_on } }
    end
    
    render json: result
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: 404
  end

  def get_product_recommendations(args)
    primary_product = Product.find(args['product_id'])
    
    recommendations = ProductRecommendation
      .includes(:recommended_product)
      .where(primary_product_id: args['product_id'], active: true)
      .order(:display_order)
    
    if args['recommendation_type'].present?
      recommendations = recommendations.where(recommendation_type: args['recommendation_type'])
    end
    
    results = recommendations.limit(10).map do |rec|
      {
        type: rec.recommendation_type,
        confidence_score: rec.confidence_score,
        product: {
          id: rec.recommended_product.id,
          name: rec.recommended_product.name,
          price: rec.recommended_product.price,
          use_on: rec.recommended_product.use_on
        }
      }
    end
    
    render json: { 
      primary_product: primary_product.name,
      recommendations: results 
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Product not found" }, status: 404
  end

  def suggest_for_project(args)
    project_ideas = ProjectIdea.includes(project_products: :product)
      .where("project_type ILIKE ?", "%#{args['project_type']}%")
    
    if args['skill_level'].present?
      project_ideas = project_ideas.where(difficulty_level: args['skill_level'])
    end
    
    results = project_ideas.limit(5).map do |project|
      products_needed = project.project_products.map do |pp|
        {
          product: {
            id: pp.product.id,
            name: pp.product.name,
            price: pp.product.price,
            use_on: pp.product.use_on
          },
          quantity_needed: pp.quantity_needed,
          notes: pp.notes
        }
      end
      
      {
        id: project.id,
        title: project.title,
        description: project.description,
        difficulty_level: project.difficulty_level,
        estimated_time: project.estimated_time,
        finished_size: project.finished_size,
        products_needed: products_needed
      }
    end
    
    render json: { project_suggestions: results }
  end

  def get_technique_guide(args)
    guides = TechniqueGuide.where("title ILIKE ? OR technique_type ILIKE ?", 
                                 "%#{args['technique_name']}%", "%#{args['technique_name']}%")
    
    if args['difficulty_level'].present?
      guides = guides.where(difficulty_level: args['difficulty_level'])
    end
    
    results = guides.where(active: true).limit(5).map do |guide|
      {
        id: guide.id,
        title: guide.title,
        technique_type: guide.technique_type,
        difficulty_level: guide.difficulty_level,
        description: guide.description,
        instructions: guide.instructions,
        tools_needed: guide.tools_needed,
        time_estimate: guide.time_estimate,
        video_url: guide.video_url
      }
    end
    
    render json: { technique_guides: results }
  end

  def get_agent_guidance(args)
    guidance = get_contextual_guidance(args['context_type'], args['category'], args['conditions'])
    render json: { guidance: guidance }
  end

  def search_support(args)
    # Search FAQs
    faqs = FrequentlyAskedQuestion
      .where("question ILIKE ? OR answer ILIKE ?", "%#{args['query']}%", "%#{args['query']}%")
      .where(active: true)
      .order(:display_order)
      .limit(5)
    
    # Search Support Articles
    articles = SupportArticle
      .where("title ILIKE ? OR content ILIKE ?", "%#{args['query']}%", "%#{args['query']}%")
      .where(published: true)
      .order(:helpful_count)
      .limit(5)
    
    if args['category'].present?
      faqs = faqs.where(category: args['category'])
      articles = articles.where(category: args['category'])
    end
    
    results = {
      faqs: faqs.map do |faq|
        {
          id: faq.id,
          question: faq.question,
          answer: faq.answer,
          category: faq.category
        }
      end,
      articles: articles.map do |article|
        {
          id: article.id,
          title: article.title,
          content: article.content.truncate(500),
          category: article.category,
          helpful_count: article.helpful_count
        }
      end
    }
    
    render json: results
  end

  def get_contextual_guidance(context_type, category = nil, conditions = nil)
    guidance = AgentGuidance.where(context_type: context_type, active: true)
    
    if category.present?
      guidance = guidance.where(category: category)
    end
    
    # Simple condition matching - in production you'd want more sophisticated matching
    selected_guidance = guidance.order(:priority).first
    
    return nil unless selected_guidance
    
    {
      context_type: selected_guidance.context_type,
      guidance_text: selected_guidance.guidance_text,
      suggested_actions: JSON.parse(selected_guidance.suggested_actions || '[]')
    }
  end
end