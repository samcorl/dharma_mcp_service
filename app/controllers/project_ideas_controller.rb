class ProjectIdeasController < ApplicationController
  before_action :set_project_idea, only: %i[ show update destroy ]

  # GET /project_ideas
  def index
    @project_ideas = ProjectIdea.all

    render json: @project_ideas
  end

  # GET /project_ideas/1
  def show
    render json: @project_idea
  end

  # POST /project_ideas
  def create
    @project_idea = ProjectIdea.new(project_idea_params)

    if @project_idea.save
      render json: @project_idea, status: :created, location: @project_idea
    else
      render json: @project_idea.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /project_ideas/1
  def update
    if @project_idea.update(project_idea_params)
      render json: @project_idea
    else
      render json: @project_idea.errors, status: :unprocessable_entity
    end
  end

  # DELETE /project_ideas/1
  def destroy
    @project_idea.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_idea
      @project_idea = ProjectIdea.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_idea_params
      params.require(:project_idea).permit(:title, :description, :difficulty_level, :project_type, :estimated_time, :finished_size, :instructions, :images, :active)
    end
end
