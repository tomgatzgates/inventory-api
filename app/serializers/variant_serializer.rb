class VariantSerializer < ActiveModel::Serializer
  attributes :id,
             :sku,
             :price,
             :option1,
             :option2,
             :option3

  belongs_to :product
end
