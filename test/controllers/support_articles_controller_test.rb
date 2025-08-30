require "test_helper"

class SupportArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @support_article = support_articles(:one)
  end

  test "should get index" do
    get support_articles_url, as: :json
    assert_response :success
  end

  test "should create support_article" do
    assert_difference("SupportArticle.count") do
      post support_articles_url, params: { support_article: { category: @support_article.category, content: @support_article.content, helpful_count: @support_article.helpful_count, published: @support_article.published, tags: @support_article.tags, title: @support_article.title, view_count: @support_article.view_count } }, as: :json
    end

    assert_response :created
  end

  test "should show support_article" do
    get support_article_url(@support_article), as: :json
    assert_response :success
  end

  test "should update support_article" do
    patch support_article_url(@support_article), params: { support_article: { category: @support_article.category, content: @support_article.content, helpful_count: @support_article.helpful_count, published: @support_article.published, tags: @support_article.tags, title: @support_article.title, view_count: @support_article.view_count } }, as: :json
    assert_response :success
  end

  test "should destroy support_article" do
    assert_difference("SupportArticle.count", -1) do
      delete support_article_url(@support_article), as: :json
    end

    assert_response :no_content
  end
end
