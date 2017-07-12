require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_many(:variants).dependent(:destroy) }
  it { should have_many(:metafields).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
  it { should validate_numericality_of(:price).is_greater_than(0) }

  describe 'metadata' do
    subject(:metadata) { product.metadata }

    let(:product) { create(:product) }

    before do
      create :metafield, key: 'farm', value: 'planalto', product: product
      create :metafield, key: 'altitude', value: 500, suffix: 'm', product: product
    end

    it 'returns a hash of all the metadata' do
      is_expected.to eq({'farm' => 'planalto', 'altitude' => '500m'})
    end
  end
end
