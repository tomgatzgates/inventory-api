class Variant < ApplicationRecord
  belongs_to :product

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: { case_insenstive: true }
  validates :option1, uniqueness: { scope: [:product_id, :option2, :option3] }, if: :option1
  validates :option2, uniqueness: { scope: [:product_id, :option1, :option3] }, if: :option2
  validates :option3, uniqueness: { scope: [:product_id, :option1, :option2] }, if: :option3
  before_validation :generate_sku, unless: :sku

  private

  def generate_sku
    self[:sku] = loop do
      str = "sku_#{SecureRandom.hex(5)}".upcase
      break str if Variant.where(sku: sku).count.zero?
    end
  end
end
