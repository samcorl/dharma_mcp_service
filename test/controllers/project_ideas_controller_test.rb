require "test_helper"

class ProjectIdeasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_idea = project_ideas(:one)
  end

  test "should get index" do
    get project_ideas_url, as: :json
    assert_response :success
  end

  test "should create project_idea" do
    assert_difference("ProjectIdea.count") do
      post project_ideas_url, params: { project_idea: { active: @project_idea.active, description: @project_idea.description, difficulty_level: @project_idea.difficulty_level, estimated_time: @project_idea.estimated_time, finished_size: @project_idea.finished_size, images: @project_idea.images, instructions: @project_idea.instructions, project_type: @project_idea.project_type, title: @project_idea.title } }, as: :json
    end

    assert_response :created
  end

  test "should show project_idea" do
    get project_idea_url(@project_idea), as: :json
    assert_response :success
  end

  test "should update project_idea" do
    patch project_idea_url(@project_idea), params: { project_idea: { active: @project_idea.active, description: @project_idea.description, difficulty_level: @project_idea.difficulty_level, estimated_time: @project_idea.estimated_time, finished_size: @project_idea.finished_size, images: @project_idea.images, instructions: @project_idea.instructions, project_type: @project_idea.project_type, title: @project_idea.title } }, as: :json
    assert_response :success
  end

  test "should destroy project_idea" do
    assert_difference("ProjectIdea.count", -1) do
      delete project_idea_url(@project_idea), as: :json
    end

    assert_response :no_content
  end
end
