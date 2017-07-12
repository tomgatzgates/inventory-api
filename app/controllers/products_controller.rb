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
      create_or_update_variants if variants_params.values.any?
      create_or_update_metafields if metafields_params.values.any?
    end

    render_json(@product, :created)
  end

  def update
    ActiveRecord::Base.transaction do
      @product.update!(product_params)
      create_or_update_variants if variants_params.values.any?
      create_or_update_metafields if metafields_params.values.any?
    end

    render_json(@product)
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def create_or_update_variants
    variants_params[:variants].each do |variant_params|
      variant = @product.variants.find_or_initialize_by(id: variant_params[:id])
      variant.update!(variant_params)
    end
  end

  def create_or_update_metafields
    metafields_params[:metafields].each do |metafield_params|
      metafield = @product.metafields.find_or_initialize_by(id: metafield_params[:id])
      metafield.update!(metafield_params)
    end
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:name, :price)
  end

  def variants_params
    params.permit(variants: [:id, :option1, :option2, :option3, :price])
  end

  def metafields_params
    params.permit(metafields: [:id, :key, :value, :prefix, :suffix])
  end
end
