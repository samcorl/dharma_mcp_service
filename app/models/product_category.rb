class ProductCategory < ApplicationRecord
  belongs_to :parent_category, class_name: 'ProductCategory', optional: true
  has_many :child_categories, class_name: 'ProductCategory', foreign_key: 'parent_category_id'
  has_many :products
end
