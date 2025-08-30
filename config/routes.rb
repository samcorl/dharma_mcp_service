Rails.application.routes.draw do
  # MCP Server endpoints
  get 'mcp/tools/list', to: 'mcp#tools_list'
  post 'mcp/tools/call', to: 'mcp#call_tool'
  
  resources :agent_guidances
  resources :support_articles
  resources :frequently_asked_questions
  resources :featured_artist_pages
  resources :project_products
  resources :project_ideas
  resources :technique_guides
  resources :product_recommendations
  resources :product_variant_lists
  resources :products
  resources :product_categories
  resources :product_families
  resources :craft_instructions_pages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
