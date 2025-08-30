class TechniqueGuidesController < ApplicationController
  before_action :set_technique_guide, only: %i[ show update destroy ]

  # GET /technique_guides
  def index
    @technique_guides = TechniqueGuide.all

    render json: @technique_guides
  end

  # GET /technique_guides/1
  def show
    render json: @technique_guide
  end

  # POST /technique_guides
  def create
    @technique_guide = TechniqueGuide.new(technique_guide_params)

    if @technique_guide.save
      render json: @technique_guide, status: :created, location: @technique_guide
    else
      render json: @technique_guide.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /technique_guides/1
  def update
    if @technique_guide.update(technique_guide_params)
      render json: @technique_guide
    else
      render json: @technique_guide.errors, status: :unprocessable_entity
    end
  end

  # DELETE /technique_guides/1
  def destroy
    @technique_guide.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_technique_guide
      @technique_guide = TechniqueGuide.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def technique_guide_params
      params.require(:technique_guide).permit(:title, :technique_type, :difficulty_level, :description, :instructions, :tools_needed, :time_estimate, :video_url, :images, :active)
    end
end
