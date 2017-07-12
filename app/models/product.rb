class Product < ApplicationRecord
  has_many :variants, dependent: :destroy
  has_many :metafields, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
