class ProductVariantListsController < ApplicationController
  before_action :set_product_variant_list, only: %i[ show update destroy ]

  # GET /product_variant_lists
  def index
    @product_variant_lists = ProductVariantList.all

    render json: @product_variant_lists
  end

  # GET /product_variant_lists/1
  def show
    render json: @product_variant_list
  end

  # POST /product_variant_lists
  def create
    @product_variant_list = ProductVariantList.new(product_variant_list_params)

    if @product_variant_list.save
      render json: @product_variant_list, status: :created, location: @product_variant_list
    else
      render json: @product_variant_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_variant_lists/1
  def update
    if @product_variant_list.update(product_variant_list_params)
      render json: @product_variant_list
    else
      render json: @product_variant_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /product_variant_lists/1
  def destroy
    @product_variant_list.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_variant_list
      @product_variant_list = ProductVariantList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_variant_list_params
      params.require(:product_variant_list).permit(:product_id, :variant_type, :variant_value, :price_modifier, :sku_suffix, :available, :color_name, :color_hex, :size_label, :inventory_count)
    end
end
