class CreateProductFamilies < ActiveRecord::Migration[7.2]
  def change
    create_table :product_families do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.integer :display_order
      t.boolean :active

      t.timestamps
    end
  end
end
