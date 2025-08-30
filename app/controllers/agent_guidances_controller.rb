class AgentGuidancesController < ApplicationController
  before_action :set_agent_guidance, only: %i[ show update destroy ]

  # GET /agent_guidances
  def index
    @agent_guidances = AgentGuidance.all

    render json: @agent_guidances
  end

  # GET /agent_guidances/1
  def show
    render json: @agent_guidance
  end

  # POST /agent_guidances
  def create
    @agent_guidance = AgentGuidance.new(agent_guidance_params)

    if @agent_guidance.save
      render json: @agent_guidance, status: :created, location: @agent_guidance
    else
      render json: @agent_guidance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agent_guidances/1
  def update
    if @agent_guidance.update(agent_guidance_params)
      render json: @agent_guidance
    else
      render json: @agent_guidance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /agent_guidances/1
  def destroy
    @agent_guidance.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_guidance
      @agent_guidance = AgentGuidance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agent_guidance_params
      params.require(:agent_guidance).permit(:context_type, :category, :conditions, :guidance_text, :suggested_actions, :priority, :active)
    end
end
