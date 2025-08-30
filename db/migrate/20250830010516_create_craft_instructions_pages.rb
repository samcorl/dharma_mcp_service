class CreateCraftInstructionsPages < ActiveRecord::Migration[7.2]
  def change
    create_table :craft_instructions_pages do |t|
      t.string :title
      t.text :content
      t.string :difficulty_level
      t.integer :estimated_time
      t.text :materials_needed
      t.text :steps
      t.text :images

      t.timestamps
    end
  end
end
