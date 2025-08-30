class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :sku
      t.decimal :weight
      t.string :dimensions
      t.boolean :availability
      t.references :product_family, null: false, foreign_key: true
      t.references :product_category, null: false, foreign_key: true
      t.text :available_colors
      t.text :available_sizes
      t.string :fiber_content
      t.string :weight_category
      t.integer :yardage
      t.text :care_instructions
      t.string :skill_level_required
      t.text :compatible_techniques
      t.text :recommended_for
      t.text :use_on

      t.timestamps
    end
  end
end
