require "test_helper"

class FeaturedArtistPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @featured_artist_page = featured_artist_pages(:one)
  end

  test "should get index" do
    get featured_artist_pages_url, as: :json
    assert_response :success
  end

  test "should create featured_artist_page" do
    assert_difference("FeaturedArtistPage.count") do
      post featured_artist_pages_url, params: { featured_artist_page: { active: @featured_artist_page.active, artist_name: @featured_artist_page.artist_name, bio: @featured_artist_page.bio, featured_image: @featured_artist_page.featured_image, featured_until: @featured_artist_page.featured_until, portfolio_images: @featured_artist_page.portfolio_images, social_links: @featured_artist_page.social_links } }, as: :json
    end

    assert_response :created
  end

  test "should show featured_artist_page" do
    get featured_artist_page_url(@featured_artist_page), as: :json
    assert_response :success
  end

  test "should update featured_artist_page" do
    patch featured_artist_page_url(@featured_artist_page), params: { featured_artist_page: { active: @featured_artist_page.active, artist_name: @featured_artist_page.artist_name, bio: @featured_artist_page.bio, featured_image: @featured_artist_page.featured_image, featured_until: @featured_artist_page.featured_until, portfolio_images: @featured_artist_page.portfolio_images, social_links: @featured_artist_page.social_links } }, as: :json
    assert_response :success
  end

  test "should destroy featured_artist_page" do
    assert_difference("FeaturedArtistPage.count", -1) do
      delete featured_artist_page_url(@featured_artist_page), as: :json
    end

    assert_response :no_content
  end
end
