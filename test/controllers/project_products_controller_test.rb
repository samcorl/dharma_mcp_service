require "test_helper"

class ProjectProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_product = project_products(:one)
  end

  test "should get index" do
    get project_products_url, as: :json
    assert_response :success
  end

  test "should create project_product" do
    assert_difference("ProjectProduct.count") do
      post project_products_url, params: { project_product: { notes: @project_product.notes, product_id: @project_product.product_id, project_idea_id: @project_product.project_idea_id, quantity_needed: @project_product.quantity_needed } }, as: :json
    end

    assert_response :created
  end

  test "should show project_product" do
    get project_product_url(@project_product), as: :json
    assert_response :success
  end

  test "should update project_product" do
    patch project_product_url(@project_product), params: { project_product: { notes: @project_product.notes, product_id: @project_product.product_id, project_idea_id: @project_product.project_idea_id, quantity_needed: @project_product.quantity_needed } }, as: :json
    assert_response :success
  end

  test "should destroy project_product" do
    assert_difference("ProjectProduct.count", -1) do
      delete project_product_url(@project_product), as: :json
    end

    assert_response :no_content
  end
end
