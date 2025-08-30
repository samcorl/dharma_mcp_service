class CraftInstructionsPagesController < ApplicationController
  before_action :set_craft_instructions_page, only: %i[ show update destroy ]

  # GET /craft_instructions_pages
  def index
    @craft_instructions_pages = CraftInstructionsPage.all

    render json: @craft_instructions_pages
  end

  # GET /craft_instructions_pages/1
  def show
    render json: @craft_instructions_page
  end

  # POST /craft_instructions_pages
  def create
    @craft_instructions_page = CraftInstructionsPage.new(craft_instructions_page_params)

    if @craft_instructions_page.save
      render json: @craft_instructions_page, status: :created, location: @craft_instructions_page
    else
      render json: @craft_instructions_page.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /craft_instructions_pages/1
  def update
    if @craft_instructions_page.update(craft_instructions_page_params)
      render json: @craft_instructions_page
    else
      render json: @craft_instructions_page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /craft_instructions_pages/1
  def destroy
    @craft_instructions_page.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_craft_instructions_page
      @craft_instructions_page = CraftInstructionsPage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def craft_instructions_page_params
      params.require(:craft_instructions_page).permit(:title, :content, :difficulty_level, :estimated_time, :materials_needed, :steps, :images)
    end
end
