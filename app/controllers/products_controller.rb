class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    render_json Product.all
  end

  def show
    render_json @product
  end

  def create
    ActiveRecord::Base.transaction do
      @product = Product.create!(product_params)
      create_variants if variants_params.values.any?
    end

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

  def create_variants
    variants_params[:variants].each do |variant_params|
      @product.variants.create!(variant_params)
    end
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:name, :price)
  end

  def variants_params
    params.permit(variants: [:option1, :option2, :option3, :price])
  end
end
