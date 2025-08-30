class ProductFamiliesController < ApplicationController
  before_action :set_product_family, only: %i[ show update destroy ]

  # GET /product_families
  def index
    @product_families = ProductFamily.all

    render json: @product_families
  end

  # GET /product_families/1
  def show
    render json: @product_family
  end

  # POST /product_families
  def create
    @product_family = ProductFamily.new(product_family_params)

    if @product_family.save
      render json: @product_family, status: :created, location: @product_family
    else
      render json: @product_family.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_families/1
  def update
    if @product_family.update(product_family_params)
      render json: @product_family
    else
      render json: @product_family.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_families/1
  def destroy
    @product_family.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_family
      @product_family = ProductFamily.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_family_params
      params.require(:product_family).permit(:name, :description, :slug, :display_order, :active)
    end
end
