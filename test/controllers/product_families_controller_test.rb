require "test_helper"

class ProductFamiliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_family = product_families(:one)
  end

  test "should get index" do
    get product_families_url, as: :json
    assert_response :success
  end

  test "should create product_family" do
    assert_difference("ProductFamily.count") do
      post product_families_url, params: { product_family: { active: @product_family.active, description: @product_family.description, display_order: @product_family.display_order, name: @product_family.name, slug: @product_family.slug } }, as: :json
    end

    assert_response :created
  end

  test "should show product_family" do
    get product_family_url(@product_family), as: :json
    assert_response :success
  end

  test "should update product_family" do
    patch product_family_url(@product_family), params: { product_family: { active: @product_family.active, description: @product_family.description, display_order: @product_family.display_order, name: @product_family.name, slug: @product_family.slug } }, as: :json
    assert_response :success
  end

  test "should destroy product_family" do
    assert_difference("ProductFamily.count", -1) do
      delete product_family_url(@product_family), as: :json
    end

    assert_response :no_content
  end
end
