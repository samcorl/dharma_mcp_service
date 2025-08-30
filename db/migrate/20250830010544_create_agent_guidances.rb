class CreateAgentGuidances < ActiveRecord::Migration[7.2]
  def change
    create_table :agent_guidances do |t|
      t.string :context_type
      t.string :category
      t.text :conditions
      t.text :guidance_text
      t.text :suggested_actions
      t.integer :priority
      t.boolean :active

      t.timestamps
    end
  end
end
