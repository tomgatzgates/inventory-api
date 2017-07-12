FactoryGirl.define do
  factory :metafield do
    product
    key 'Origin'
    value { Faker::Coffee.origin }
  end
end
