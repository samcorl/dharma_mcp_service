class CreateFrequentlyAskedQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :frequently_asked_questions do |t|
      t.string :question
      t.text :answer
      t.string :category
      t.integer :display_order
      t.boolean :active

      t.timestamps
    end
  end
end
