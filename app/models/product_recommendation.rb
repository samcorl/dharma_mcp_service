class ProductRecommendation < ApplicationRecord
  belongs_to :primary_product
  belongs_to :recommended_product
end
