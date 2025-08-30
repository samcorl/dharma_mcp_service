require "test_helper"

class AgentGuidancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent_guidance = agent_guidances(:one)
  end

  test "should get index" do
    get agent_guidances_url, as: :json
    assert_response :success
  end

  test "should create agent_guidance" do
    assert_difference("AgentGuidance.count") do
      post agent_guidances_url, params: { agent_guidance: { active: @agent_guidance.active, category: @agent_guidance.category, conditions: @agent_guidance.conditions, context_type: @agent_guidance.context_type, guidance_text: @agent_guidance.guidance_text, priority: @agent_guidance.priority, suggested_actions: @agent_guidance.suggested_actions } }, as: :json
    end

    assert_response :created
  end

  test "should show agent_guidance" do
    get agent_guidance_url(@agent_guidance), as: :json
    assert_response :success
  end

  test "should update agent_guidance" do
    patch agent_guidance_url(@agent_guidance), params: { agent_guidance: { active: @agent_guidance.active, category: @agent_guidance.category, conditions: @agent_guidance.conditions, context_type: @agent_guidance.context_type, guidance_text: @agent_guidance.guidance_text, priority: @agent_guidance.priority, suggested_actions: @agent_guidance.suggested_actions } }, as: :json
    assert_response :success
  end

  test "should destroy agent_guidance" do
    assert_difference("AgentGuidance.count", -1) do
      delete agent_guidance_url(@agent_guidance), as: :json
    end

    assert_response :no_content
  end
end
