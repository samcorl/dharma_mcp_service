require "test_helper"

class FrequentlyAskedQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @frequently_asked_question = frequently_asked_questions(:one)
  end

  test "should get index" do
    get frequently_asked_questions_url, as: :json
    assert_response :success
  end

  test "should create frequently_asked_question" do
    assert_difference("FrequentlyAskedQuestion.count") do
      post frequently_asked_questions_url, params: { frequently_asked_question: { active: @frequently_asked_question.active, answer: @frequently_asked_question.answer, category: @frequently_asked_question.category, display_order: @frequently_asked_question.display_order, question: @frequently_asked_question.question } }, as: :json
    end

    assert_response :created
  end

  test "should show frequently_asked_question" do
    get frequently_asked_question_url(@frequently_asked_question), as: :json
    assert_response :success
  end

  test "should update frequently_asked_question" do
    patch frequently_asked_question_url(@frequently_asked_question), params: { frequently_asked_question: { active: @frequently_asked_question.active, answer: @frequently_asked_question.answer, category: @frequently_asked_question.category, display_order: @frequently_asked_question.display_order, question: @frequently_asked_question.question } }, as: :json
    assert_response :success
  end

  test "should destroy frequently_asked_question" do
    assert_difference("FrequentlyAskedQuestion.count", -1) do
      delete frequently_asked_question_url(@frequently_asked_question), as: :json
    end

    assert_response :no_content
  end
end
