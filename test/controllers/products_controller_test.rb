require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url, as: :json
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { availability: @product.availability, available_colors: @product.available_colors, available_sizes: @product.available_sizes, care_instructions: @product.care_instructions, compatible_techniques: @product.compatible_techniques, description: @product.description, dimensions: @product.dimensions, fiber_content: @product.fiber_content, name: @product.name, price: @product.price, product_category_id: @product.product_category_id, product_family_id: @product.product_family_id, recommended_for: @product.recommended_for, skill_level_required: @product.skill_level_required, sku: @product.sku, use_on: @product.use_on, weight: @product.weight, weight_category: @product.weight_category, yardage: @product.yardage } }, as: :json
    end

    assert_response :created
  end

  test "should show product" do
    get product_url(@product), as: :json
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { availability: @product.availability, available_colors: @product.available_colors, available_sizes: @product.available_sizes, care_instructions: @product.care_instructions, compatible_techniques: @product.compatible_techniques, description: @product.description, dimensions: @product.dimensions, fiber_content: @product.fiber_content, name: @product.name, price: @product.price, product_category_id: @product.product_category_id, product_family_id: @product.product_family_id, recommended_for: @product.recommended_for, skill_level_required: @product.skill_level_required, sku: @product.sku, use_on: @product.use_on, weight: @product.weight, weight_category: @product.weight_category, yardage: @product.yardage } }, as: :json
    assert_response :success
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product), as: :json
    end

    assert_response :no_content
  end
end
