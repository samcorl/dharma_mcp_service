require "test_helper"

class ProductRecommendationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_recommendation = product_recommendations(:one)
  end

  test "should get index" do
    get product_recommendations_url, as: :json
    assert_response :success
  end

  test "should create product_recommendation" do
    assert_difference("ProductRecommendation.count") do
      post product_recommendations_url, params: { product_recommendation: { active: @product_recommendation.active, confidence_score: @product_recommendation.confidence_score, display_order: @product_recommendation.display_order, primary_product_id: @product_recommendation.primary_product_id, recommendation_type: @product_recommendation.recommendation_type, recommended_product_id: @product_recommendation.recommended_product_id } }, as: :json
    end

    assert_response :created
  end

  test "should show product_recommendation" do
    get product_recommendation_url(@product_recommendation), as: :json
    assert_response :success
  end

  test "should update product_recommendation" do
    patch product_recommendation_url(@product_recommendation), params: { product_recommendation: { active: @product_recommendation.active, confidence_score: @product_recommendation.confidence_score, display_order: @product_recommendation.display_order, primary_product_id: @product_recommendation.primary_product_id, recommendation_type: @product_recommendation.recommendation_type, recommended_product_id: @product_recommendation.recommended_product_id } }, as: :json
    assert_response :success
  end

  test "should destroy product_recommendation" do
    assert_difference("ProductRecommendation.count", -1) do
      delete product_recommendation_url(@product_recommendation), as: :json
    end

    assert_response :no_content
  end
end
