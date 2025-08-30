class CreateProjectProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :project_products do |t|
      t.references :project_idea, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :quantity_needed
      t.string :notes

      t.timestamps
    end
  end
end
