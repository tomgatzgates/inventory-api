class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    render_json Product.all
  end

  def show
    render_json @product
  end

  def create
    @product = Product.create!(product_params)
    render_json(@product, :created)
  end

  def update
    @product.update!(product_params)
    render_json(@product)
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:name, :price)
  end
end
