RSpec.describe UserSessionRoutes, type: :routes do
  describe 'POST /' do
    def perform_request(params)
      post '/', params
    end

    let(:email) { 'test@mail.test' }
    let(:password) { '1243qwerty' }

    let!(:user) { create(:user, email: email, password: password) }

    let(:params) do
      {
        email: 'test@mail.test',
        password: '1243qwerty'
      }
    end

    let(:jwt_format) do
      %r{^[A-Za-z0-9\-_=]+\.[A-Za-z0-9\-_=]+\.?[A-Za-z0-9\-_.+/=]*$}
    end

    before do
      perform_request(params)
    end

    context 'valid parameters' do
      it 'responds successfully ' do
        expect(last_response.status).to eq(201)
      end

      it 'returns an expected schema' do
        expect(last_response).to match_response_schema("token")
        end

      it 'returns a token' do
        expect(response_body['meta']['token']).to be_present
        end

      it 'returns a token with an expected format' do
        expect(response_body['meta']['token']).to match(jwt_format)
      end
    end

    context 'invalid parameters' do
      shared_examples :invalid_params do
        context 'missing key' do
          let(:error_details) { "{:#{key}=>[\"is missing\"]}" }

          before do
            params.delete(key)
            perform_request(params)
          end

          it_behaves_like 'api/params_failure'
        end

        context 'null value' do
          let(:error_details) { "{:#{key}=>[\"must be filled\"]}" }

          before do
            params[key] = nil
            perform_request(params)
          end

          it_behaves_like 'api/params_failure'
        end

        context 'invalid type' do
          let(:error_details) { "{:#{key}=>[\"must be a string\"]}" }

          before do
            params[key] = { test: 'test' }
            perform_request(params)
          end

          it_behaves_like 'api/params_failure'
        end
      end

      context '#email' do
        let(:key) { :email }

        include_examples :invalid_params
      end

      context '#password' do
        let(:key) { :password }

        include_examples :invalid_params
      end
    end
  end
end
