class Variant < ApplicationRecord
  belongs_to :product

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: { case_insenstive: true }

  before_validation :generate_sku, unless: :sku

  private

  def generate_sku
    self[:sku] = loop do
      str = "sku_#{SecureRandom.hex(5)}".upcase
      break str if Variant.where(sku: sku).count.zero?
    end
  end
end
