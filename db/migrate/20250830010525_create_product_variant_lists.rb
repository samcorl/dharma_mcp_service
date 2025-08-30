class CreateProductVariantLists < ActiveRecord::Migration[7.2]
  def change
    create_table :product_variant_lists do |t|
      t.references :product, null: false, foreign_key: true
      t.string :variant_type
      t.string :variant_value
      t.decimal :price_modifier
      t.string :sku_suffix
      t.boolean :available
      t.string :color_name
      t.string :color_hex
      t.string :size_label
      t.integer :inventory_count

      t.timestamps
    end
  end
end
