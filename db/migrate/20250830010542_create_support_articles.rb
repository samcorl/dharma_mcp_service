class CreateSupportArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :support_articles do |t|
      t.string :title
      t.text :content
      t.string :category
      t.string :tags
      t.integer :helpful_count
      t.integer :view_count
      t.boolean :published

      t.timestamps
    end
  end
end
