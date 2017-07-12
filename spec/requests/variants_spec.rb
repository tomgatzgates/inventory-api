require 'rails_helper'

RSpec.describe 'Variants API', type: :request do
  let(:product) { create :product }

  describe 'GET /products/:product_id/variants' do
    before do
      create_list :variant, 10, product: product
      get "/products/#{product.id}/variants"
    end

    it 'returns variants' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /products/:product_id/variants/:id' do
    let(:variant_id) { create(:variant, product: product).id }

    before { get "/products/#{product.id}/variants/#{variant_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(variant_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:variant_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Variant/)
      end
    end
  end

  describe 'POST /products/:product_id/variants' do
    context 'when the request is valid' do
      let(:valid_attributes) { { option1: '500g', price: 10 } }

      before { post "/products/#{product.id}/variants", params: valid_attributes }

      it 'creates a variant' do
        expect(json['option1']).to eq('500g')
        expect(Variant.count).to eq 1
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post "/products/#{product.id}/variants", params: invalid_attributes }

      context 'invalid variant' do
        let(:invalid_attributes) { { option1: '500g', price: nil } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Price can't be blank/)
        end
      end

      context 'duplicate option sets' do
        let(:variant) { create :variant, product: product, option1: '500g' }
        let(:invalid_attributes) { { option1: variant.option1, price: variant.price } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Option1 has already been taken/)
        end
      end
    end
  end
end
