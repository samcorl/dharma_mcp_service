class CreateFeaturedArtistPages < ActiveRecord::Migration[7.2]
  def change
    create_table :featured_artist_pages do |t|
      t.string :artist_name
      t.text :bio
      t.string :featured_image
      t.text :portfolio_images
      t.text :social_links
      t.datetime :featured_until
      t.boolean :active

      t.timestamps
    end
  end
end
