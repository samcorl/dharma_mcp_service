class CreateProjectIdeas < ActiveRecord::Migration[7.2]
  def change
    create_table :project_ideas do |t|
      t.string :title
      t.text :description
      t.string :difficulty_level
      t.string :project_type
      t.integer :estimated_time
      t.string :finished_size
      t.text :instructions
      t.text :images
      t.boolean :active

      t.timestamps
    end
  end
end
