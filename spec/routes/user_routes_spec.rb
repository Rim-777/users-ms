RSpec.describe UserRoutes, type: :routes do
  let(:user_id_ref) { 101 }

  describe 'GET /v1/users' do
    before do
      create_list(:user, 3)
      get '/v1/users'
    end

    it 'returns a collection of users' do
      expect(last_response.status).to eq(200)
    end

    it do
      expect(response_body['data'].size).to eq(3)
    end

    it 'contains pagination links' do
      expect(response_body['links'])
        .to eq({ 'first' => '/v1/users?page=1', 'last' => '/v1/users?page=1' })
    end

    it 'responds with an expected response body' do
      User.all.each_index do |i|
        expect(response_body['data'][i])
          .to a_hash_including(
                {
                  'attributes' => a_hash_including({
                                                     'first_name' => 'Timo',
                                                     'last_name' => 'Moss',
                                                   }, 'email'),
                  'type' => 'user'
                }, 'id'
              )
      end
    end
  end

  describe 'POST /v1/users' do
    def post_request(params)
      post '/v1/users', params
    end

    let(:params) do
      {
        data: {
          attributes: {
            email: 'test@mail.test',
            password: '1243qwerty',
            first_name: 'Tom',
            last_name: 'Johns'
          }
        }
      }
    end

    before do
      post_request(params)
    end

    context 'valid parameters' do
      let(:expected_response_body) do
        {
          'id' => User.last.id.to_s,
          'type' => 'user',
          'attributes' => {
            "email" => "test@mail.test",
            "first_name" => "Tom",
            "last_name" => "Johns" }
        }
      end

      it 'responds successfully ' do
        expect(last_response.status).to eq(201)
      end

      it 'returns user data' do
        expect(response_body['data']).to eq(expected_response_body)
      end
    end

    context 'invalid parameters' do
      it_behaves_like 'api/data_root_key_failure'

      shared_examples :invalid_params do
        context 'missing key' do
          let(:error_details) { "{:data=>{:attributes=>{:#{key}=>[\"is missing\"]}}}" }

          before do
            params[:data][:attributes].delete(key)
            post_request(params)
          end

          it_behaves_like 'api/params_failure'
        end

        context 'null value' do
          let(:error_details) { "{:data=>{:attributes=>{:#{key}=>[\"must be filled\"]}}}" }

          before do
            params[:data][:attributes][key] = nil
            post_request(params)
          end

          it_behaves_like 'api/params_failure'
        end

        context 'invalid type' do
          let(:error_details) { "{:data=>{:attributes=>{:#{key}=>[\"must be a string\"]}}}" }

          before do
            params[:data][:attributes][key] = { test: 'test' }
            post_request(params)
          end

          it_behaves_like 'api/params_failure'
        end
      end

      context '#data/attributes/email' do
        let(:key) { :email }

        include_examples :invalid_params

        context 'invalid format' do
          let(:error_details) { "{:data=>{:attributes=>{:#{key}=>[\"invalid format\"]}}}" }

          before do
            params[:data][:attributes][key] = 'test@'
            post_request(params)
          end

          it_behaves_like 'api/params_failure'
        end
      end

      context '#data/attributes/password' do
        let(:key) { :password }

        include_examples :invalid_params
      end

      context '#data/attributes/first_name' do
        let(:key) { :first_name }

        include_examples :invalid_params
      end

      context '#data/attributes/last_name' do
        let(:key) { :last_name }

        include_examples :invalid_params
      end
    end
  end
end
