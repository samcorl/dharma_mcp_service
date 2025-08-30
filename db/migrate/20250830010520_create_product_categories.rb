class CreateProductCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.references :parent_category, null: true, foreign_key: { to_table: :product_categories }
      t.integer :display_order
      t.boolean :active

      t.timestamps
    end
  end
end
