class Metafield < ApplicationRecord
  belongs_to :product

  validates :key, presence: true, uniqueness: { scope: :product_id }
  validates :value, presence: true

  def value_string
    "#{prefix}#{value}#{suffix}"
  end
end
