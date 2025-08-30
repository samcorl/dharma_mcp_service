class CreateTechniqueGuides < ActiveRecord::Migration[7.2]
  def change
    create_table :technique_guides do |t|
      t.string :title
      t.string :technique_type
      t.string :difficulty_level
      t.text :description
      t.text :instructions
      t.text :tools_needed
      t.integer :time_estimate
      t.string :video_url
      t.text :images
      t.boolean :active

      t.timestamps
    end
  end
end
