FactoryGirl.define do
  factory :variant do
    product
    price { Faker::Commerce.price }
  end
end
