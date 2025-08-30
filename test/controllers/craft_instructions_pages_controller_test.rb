require "test_helper"

class CraftInstructionsPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @craft_instructions_page = craft_instructions_pages(:one)
  end

  test "should get index" do
    get craft_instructions_pages_url, as: :json
    assert_response :success
  end

  test "should create craft_instructions_page" do
    assert_difference("CraftInstructionsPage.count") do
      post craft_instructions_pages_url, params: { craft_instructions_page: { content: @craft_instructions_page.content, difficulty_level: @craft_instructions_page.difficulty_level, estimated_time: @craft_instructions_page.estimated_time, images: @craft_instructions_page.images, materials_needed: @craft_instructions_page.materials_needed, steps: @craft_instructions_page.steps, title: @craft_instructions_page.title } }, as: :json
    end

    assert_response :created
  end

  test "should show craft_instructions_page" do
    get craft_instructions_page_url(@craft_instructions_page), as: :json
    assert_response :success
  end

  test "should update craft_instructions_page" do
    patch craft_instructions_page_url(@craft_instructions_page), params: { craft_instructions_page: { content: @craft_instructions_page.content, difficulty_level: @craft_instructions_page.difficulty_level, estimated_time: @craft_instructions_page.estimated_time, images: @craft_instructions_page.images, materials_needed: @craft_instructions_page.materials_needed, steps: @craft_instructions_page.steps, title: @craft_instructions_page.title } }, as: :json
    assert_response :success
  end

  test "should destroy craft_instructions_page" do
    assert_difference("CraftInstructionsPage.count", -1) do
      delete craft_instructions_page_url(@craft_instructions_page), as: :json
    end

    assert_response :no_content
  end
end
