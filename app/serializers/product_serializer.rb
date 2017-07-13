class ProductSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :price,
             :option1,
             :option2,
             :option3,
             :metadata

  has_many :variants
end
