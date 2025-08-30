require "test_helper"

class ProductVariantListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_variant_list = product_variant_lists(:one)
  end

  test "should get index" do
    get product_variant_lists_url, as: :json
    assert_response :success
  end

  test "should create product_variant_list" do
    assert_difference("ProductVariantList.count") do
      post product_variant_lists_url, params: { product_variant_list: { available: @product_variant_list.available, color_hex: @product_variant_list.color_hex, color_name: @product_variant_list.color_name, inventory_count: @product_variant_list.inventory_count, price_modifier: @product_variant_list.price_modifier, product_id: @product_variant_list.product_id, size_label: @product_variant_list.size_label, sku_suffix: @product_variant_list.sku_suffix, variant_type: @product_variant_list.variant_type, variant_value: @product_variant_list.variant_value } }, as: :json
    end

    assert_response :created
  end

  test "should show product_variant_list" do
    get product_variant_list_url(@product_variant_list), as: :json
    assert_response :success
  end

  test "should update product_variant_list" do
    patch product_variant_list_url(@product_variant_list), params: { product_variant_list: { available: @product_variant_list.available, color_hex: @product_variant_list.color_hex, color_name: @product_variant_list.color_name, inventory_count: @product_variant_list.inventory_count, price_modifier: @product_variant_list.price_modifier, product_id: @product_variant_list.product_id, size_label: @product_variant_list.size_label, sku_suffix: @product_variant_list.sku_suffix, variant_type: @product_variant_list.variant_type, variant_value: @product_variant_list.variant_value } }, as: :json
    assert_response :success
  end

  test "should destroy product_variant_list" do
    assert_difference("ProductVariantList.count", -1) do
      delete product_variant_list_url(@product_variant_list), as: :json
    end

    assert_response :no_content
  end
end
