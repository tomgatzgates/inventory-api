require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  describe 'GET /products' do
    before do
      create_list :product, 10
      get '/products'
    end

    it 'returns products' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /products/:id' do
    let(:product_id) { create(:product).id }

    before { get "/products/#{product_id}" }

    context 'when the record exists' do
      it 'returns the product' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(product_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:product_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  describe 'POST /products' do
    context 'without variants' do
      context 'when the request is valid' do
        let(:valid_attributes) { { name: 'Coffee Bag', price: 6.95 } }

        before { post '/products', params: valid_attributes }

        it 'creates a product' do
          expect(json['name']).to eq('Coffee Bag')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post '/products', params: { name: 'Foobar' } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Price can't be blank/)
        end
      end
    end

    context 'with variants' do
      context 'when the request is valid' do
        before { post '/products', params: valid_attributes }

        let(:valid_attributes) do
          {
            name: 'Coffee Bag',
            price: 6.95,
            variants: [
              { option1: '250g', price: 5 },
              { option1: '500g', price: 10 },
            ],
          }
        end

        it 'creates a product' do
          expect(json['name']).to eq('Coffee Bag')
        end

        it 'creates variants' do
          expect(Variant.count).to eq 2
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post '/products', params: invalid_attributes }

        let(:invalid_attributes) do
          {
            name: 'Coffee Bag',
            price: 6.95,
            variants: [
              { option1: '250g', price: nil },
              { option1: '500g', price: 10 },
            ],
          }
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Price can't be blank/)
        end
      end
    end
  end

  describe 'PUT /products/:id' do
    let(:product) { create :product, name: 'Small Coffee Bag' }
    let(:product_id) { product.id }
    let(:valid_attributes) { { name: 'Big Coffee Bag' } }

    context 'when the record exists' do
      before { put "/products/#{product_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json).not_to be_empty
        expect(product.reload.name).to eq 'Big Coffee Bag'
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /products/:id' do
    let(:product) { create :product }

    before do
      create :variant, product: product
      delete "/products/#{product.id}"
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the product and variants' do
      expect(Product.find_by_id(product.id)).to be_nil
      expect(Variant.where(product_id: product.id)).to be_empty
    end
  end
end
