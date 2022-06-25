RSpec.describe AdRoutes, type: :routes do
  let(:user_id_ref) { 101 }

  describe 'GET /v1' do
    before do
      create_list(:ad, 3, user_id_ref: user_id_ref)
      get '/v1'
    end

    it 'returns a collection of ads' do
      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end

    it 'contains pagination links' do
      expect(response_body['links']).to eq({ 'first' => '/v1?page=1', 'last' => '/v1?page=1' })
    end

    it 'responds with an expected response body' do
      Ad.all.each_index do |i|
        expect(response_body['data'][i])
          .to a_hash_including(
            {
              'attributes' => {
                'city' => 'City',
                'description' => 'Ad description',
                'lat' => nil,
                'lon' => nil,
                'title' => 'Ad title'
              },
              'type' => 'ad'
            }, 'id'
          )
      end
    end
  end

  describe 'POST /v1' do
    let(:ad_params) do
      {
        ad: {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City'
        },
        user_id_ref: user_id_ref
      }
    end

    context 'valid parameters' do
      before do
        post '/v1', ad_params
      end

      let(:last_ad) { Ad.last }
      it 'creates a new ad' do
        expect(last_response.status).to eq(201)
      end

      it 'returns an ad' do
        expect(response_body['data'])
          .to a_hash_including(
            'id' => last_ad.id.to_s,
            'type' => 'ad'
          )
      end
    end

    context 'invalid parameters' do
      shared_examples :failure do
        it 'returns an expected http status' do
          expect(last_response.status).to eq(400)
        end

        it 'returns an expected error body' do
          expect(response_body['errors'])
            .to include(
              {
                'detail' => "Some of the given parameters are invalid: #{error_details}"
              }
            )
        end
      end

      context '#ad' do
        context 'missing' do
          before do
            ad_params.delete(:ad)
            post '/v1', ad_params
          end

          let(:error_details) { '{:ad=>["is missing"]}' }
          include_examples :failure
        end

        context 'invalid' do
          before do
            ad_params[:ad] = nil
            post '/v1', ad_params
          end

          let(:error_details) { '{:ad=>["must be a hash"]}' }
          include_examples :failure
        end
      end

      shared_examples :invalid_params do
        context 'missing' do
          before do
            ad_params[:ad].delete(key)
            post '/v1', ad_params
          end

          let(:error_details) { "{:ad=>{:#{key}=>[\"is missing\"]}}" }
          include_examples :failure
        end

        context 'invalid' do
          before do
            ad_params[:ad][key] = nil
            post '/v1', ad_params
          end

          let(:error_details) { "{:ad=>{:#{key}=>[\"must be filled\"]}}" }
          include_examples :failure
        end
      end

      context '#ad/city' do
        let(:key) { :city }

        include_examples :invalid_params
      end

      context '#ad/title' do
        let(:key) { :title }

        include_examples :invalid_params
      end

      context '#ad/description' do
        let(:key) { :description }

        include_examples :invalid_params
      end
    end
  end
end
