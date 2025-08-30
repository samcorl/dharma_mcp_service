require "test_helper"

class TechniqueGuidesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @technique_guide = technique_guides(:one)
  end

  test "should get index" do
    get technique_guides_url, as: :json
    assert_response :success
  end

  test "should create technique_guide" do
    assert_difference("TechniqueGuide.count") do
      post technique_guides_url, params: { technique_guide: { active: @technique_guide.active, description: @technique_guide.description, difficulty_level: @technique_guide.difficulty_level, images: @technique_guide.images, instructions: @technique_guide.instructions, technique_type: @technique_guide.technique_type, time_estimate: @technique_guide.time_estimate, title: @technique_guide.title, tools_needed: @technique_guide.tools_needed, video_url: @technique_guide.video_url } }, as: :json
    end

    assert_response :created
  end

  test "should show technique_guide" do
    get technique_guide_url(@technique_guide), as: :json
    assert_response :success
  end

  test "should update technique_guide" do
    patch technique_guide_url(@technique_guide), params: { technique_guide: { active: @technique_guide.active, description: @technique_guide.description, difficulty_level: @technique_guide.difficulty_level, images: @technique_guide.images, instructions: @technique_guide.instructions, technique_type: @technique_guide.technique_type, time_estimate: @technique_guide.time_estimate, title: @technique_guide.title, tools_needed: @technique_guide.tools_needed, video_url: @technique_guide.video_url } }, as: :json
    assert_response :success
  end

  test "should destroy technique_guide" do
    assert_difference("TechniqueGuide.count", -1) do
      delete technique_guide_url(@technique_guide), as: :json
    end

    assert_response :no_content
  end
end
