# Fiber Arts MCP Server Seed Data

# Product Families
cotton_family = ProductFamily.find_or_create_by!(slug: "cotton-fabrics") do |pf|
  pf.name = "Cotton Fabrics"
  pf.description = "Natural cotton fabrics for various projects"
  pf.display_order = 1
  pf.active = true
end

wool_family = ProductFamily.find_or_create_by!(slug: "wool-yarns") do |pf|
  pf.name = "Wool Yarns" 
  pf.description = "Premium wool yarns for knitting and crochet"
  pf.display_order = 2
  pf.active = true
end

# Product Categories
dyes_category = ProductCategory.find_or_create_by!(slug: "fabric-dyes") do |pc|
  pc.name = "Fabric Dyes"
  pc.description = "Professional fabric dyes and colorants"
  pc.display_order = 1
  pc.active = true
end

yarns_category = ProductCategory.find_or_create_by!(slug: "knitting-yarns") do |pc|
  pc.name = "Knitting Yarns"
  pc.description = "Quality yarns for knitting projects"
  pc.display_order = 2
  pc.active = true
end

# Products
fiber_reactive_dye = Product.find_or_create_by!(sku: "DR-001-RED") do |p|
  p.name = "Dharma Fiber Reactive Dye - Red"
  p.description = "Professional grade fiber reactive dye perfect for cotton, rayon, and other cellulose fibers"
  p.price = 3.95
  p.availability = true
  p.product_family = cotton_family
  p.product_category = dyes_category
  p.available_colors = '["Red", "Crimson", "Scarlet"]'
  p.available_sizes = '["2/3 oz", "1 lb"]'
  p.fiber_content = "Dye powder"
  p.use_on = "cotton, rayon, linen, hemp, bamboo"
  p.care_instructions = "Wash separately first few times"
  p.skill_level_required = "beginner"
  p.compatible_techniques = "dyeing, tie-dye, batik"
  p.recommended_for = "t-shirts, scarves, tablecloths"
end

wool_yarn = Product.find_or_create_by!(sku: "WL-DK-MER") do |p|
  p.name = "Merino Wool DK Weight"
  p.description = "Soft merino wool in DK weight, perfect for garments and accessories"
  p.price = 12.50
  p.availability = true
  p.product_family = wool_family
  p.product_category = yarns_category
  p.available_colors = '["Natural", "Charcoal", "Burgundy", "Forest Green"]'
  p.available_sizes = '["50g", "100g"]'
  p.fiber_content = "100% Merino Wool"
  p.weight_category = "DK"
  p.yardage = 231
  p.use_on = "wool"
  p.care_instructions = "Hand wash cold, lay flat to dry"
  p.skill_level_required = "intermediate" 
  p.compatible_techniques = "knitting, crochet"
  p.recommended_for = "sweaters, hats, mittens"
end

# Agent Guidance
AgentGuidance.find_or_create_by!(context_type: "no_results_found", category: "products") do |ag|
  ag.conditions = '{"search_term": "cotton dye"}'
  ag.guidance_text = "No cotton-specific dyes found. Try searching for 'fiber reactive dyes' - they work excellently on cotton, rayon, and other cellulose fibers."
  ag.suggested_actions = '["search_fiber_reactive_dyes", "browse_cellulose_dyes"]'
  ag.priority = 1
  ag.active = true
end

# FAQs
FrequentlyAskedQuestion.find_or_create_by!(question: "What's the difference between fiber reactive dyes and other dyes?") do |faq|
  faq.answer = "Fiber reactive dyes chemically bond with cellulose fibers (cotton, rayon, linen) creating permanent, wash-fast colors. They're the best choice for natural plant-based fabrics."
  faq.category = "dyeing"
  faq.display_order = 1
  faq.active = true
end

puts "✅ Seed data created successfully!"
puts "Created #{Product.count} products"
puts "Created #{AgentGuidance.count} agent guidance entries"
puts "Created #{FrequentlyAskedQuestion.count} FAQs"
