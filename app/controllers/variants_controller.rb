class VariantsController < ApplicationController
  before_action :set_product
  before_action :set_variant, only: [:show, :update]

  def index
    render_json @product.variants
  end

  def show
    render_json @variant
  end

  def create
    @variant = @product.variants.create!(variant_params)
    render_json @variant, :created
  end

  private

  def variant_params
    params.permit(:option1, :option2, :option3, :price)
  end

  def set_variant
    @variant = @product.variants.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end
end
