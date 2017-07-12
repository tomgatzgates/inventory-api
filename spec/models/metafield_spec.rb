require 'rails_helper'

RSpec.describe Metafield, type: :model do
  subject(:metafield) { create :metafield }
  it { should belong_to(:product) }
  it { should validate_presence_of(:key) }
  it { should validate_uniqueness_of(:key).scoped_to(:product_id) }
  it { should validate_presence_of(:value) }

  describe 'value_string' do
    let(:metafield) { create :metafield, value: 500, prefix: prefix, suffix: suffix }
    subject(:value_string) { metafield.value_string }

    context 'no suffix or prefix' do
      let(:prefix) { nil }
      let(:suffix) { nil }
      it { is_expected.to eq '500' }
    end

    context 'with prefix' do
      let(:prefix) { '~' }
      let(:suffix) { nil }
      it { is_expected.to eq '~500' }
    end

    context 'with suffix' do
      let(:prefix) { nil }
      let(:suffix) { 'g' }
      it { is_expected.to eq '500g' }
    end

    context 'with suffix and prefix' do
      let(:prefix) { '~' }
      let(:suffix) { 'g' }
      it { is_expected.to eq '~500g' }
    end
  end
end
