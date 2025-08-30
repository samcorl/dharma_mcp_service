class ProjectProductsController < ApplicationController
  before_action :set_project_product, only: %i[ show update destroy ]

  # GET /project_products
  def index
    @project_products = ProjectProduct.all

    render json: @project_products
  end

  # GET /project_products/1
  def show
    render json: @project_product
  end

  # POST /project_products
  def create
    @project_product = ProjectProduct.new(project_product_params)

    if @project_product.save
      render json: @project_product, status: :created, location: @project_product
    else
      render json: @project_product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /project_products/1
  def update
    if @project_product.update(project_product_params)
      render json: @project_product
    else
      render json: @project_product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /project_products/1
  def destroy
    @project_product.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_product
      @project_product = ProjectProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_product_params
      params.require(:project_product).permit(:project_idea_id, :product_id, :quantity_needed, :notes)
    end
end
