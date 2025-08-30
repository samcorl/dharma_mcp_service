class ProductRecommendationsController < ApplicationController
  before_action :set_product_recommendation, only: %i[ show update destroy ]

  # GET /product_recommendations
  def index
    @product_recommendations = ProductRecommendation.all

    render json: @product_recommendations
  end

  # GET /product_recommendations/1
  def show
    render json: @product_recommendation
  end

  # POST /product_recommendations
  def create
    @product_recommendation = ProductRecommendation.new(product_recommendation_params)

    if @product_recommendation.save
      render json: @product_recommendation, status: :created, location: @product_recommendation
    else
      render json: @product_recommendation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_recommendations/1
  def update
    if @product_recommendation.update(product_recommendation_params)
      render json: @product_recommendation
    else
      render json: @product_recommendation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_recommendations/1
  def destroy
    @product_recommendation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_recommendation
      @product_recommendation = ProductRecommendation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_recommendation_params
      params.require(:product_recommendation).permit(:primary_product_id, :recommended_product_id, :recommendation_type, :confidence_score, :display_order, :active)
    end
end
