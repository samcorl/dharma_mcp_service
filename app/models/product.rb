class Product < ApplicationRecord
  belongs_to :product_family
  belongs_to :product_category
  has_many :product_variant_lists
  has_many :project_products
  has_many :product_recommendations_as_primary, class_name: 'ProductRecommendation', foreign_key: 'primary_product_id'
  has_many :product_recommendations_as_recommended, class_name: 'ProductRecommendation', foreign_key: 'recommended_product_id'
end
