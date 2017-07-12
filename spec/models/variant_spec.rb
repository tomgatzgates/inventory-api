require 'rails_helper'

RSpec.describe Variant, type: :model do
  it { should belong_to(:product) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than(0) }

  describe 'sku' do
    it 'generates a sku before validation if none present' do
      variant = build :variant
      expect { variant.valid? }.to change { variant.sku }.from nil
    end

    it 'validates uniqueness of sku' do
      variant_1 = create :variant
      variant_2 = build :variant, sku: variant_1.sku

      expect(variant_2.valid?).to be_falsey
    end
  end
end
