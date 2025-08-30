class FrequentlyAskedQuestionsController < ApplicationController
  before_action :set_frequently_asked_question, only: %i[ show update destroy ]

  # GET /frequently_asked_questions
  def index
    @frequently_asked_questions = FrequentlyAskedQuestion.all

    render json: @frequently_asked_questions
  end

  # GET /frequently_asked_questions/1
  def show
    render json: @frequently_asked_question
  end

  # POST /frequently_asked_questions
  def create
    @frequently_asked_question = FrequentlyAskedQuestion.new(frequently_asked_question_params)

    if @frequently_asked_question.save
      render json: @frequently_asked_question, status: :created, location: @frequently_asked_question
    else
      render json: @frequently_asked_question.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /frequently_asked_questions/1
  def update
    if @frequently_asked_question.update(frequently_asked_question_params)
      render json: @frequently_asked_question
    else
      render json: @frequently_asked_question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /frequently_asked_questions/1
  def destroy
    @frequently_asked_question.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frequently_asked_question
      @frequently_asked_question = FrequentlyAskedQuestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def frequently_asked_question_params
      params.require(:frequently_asked_question).permit(:question, :answer, :category, :display_order, :active)
    end
end
