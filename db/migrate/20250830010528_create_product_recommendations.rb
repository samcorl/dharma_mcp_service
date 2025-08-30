class CreateProductRecommendations < ActiveRecord::Migration[7.2]
  def change
    create_table :product_recommendations do |t|
      t.references :primary_product, null: false, foreign_key: { to_table: :products }
      t.references :recommended_product, null: false, foreign_key: { to_table: :products }
      t.string :recommendation_type
      t.decimal :confidence_score
      t.integer :display_order
      t.boolean :active

      t.timestamps
    end
  end
end
