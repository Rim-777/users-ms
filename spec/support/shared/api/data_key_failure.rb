# frozen_string_literal: true

shared_examples 'api/data_key_failure' do
  context '#data' do
    let(:key) { :data }

    context 'missing key' do
      let(:error_details) { "{:#{key}=>[\"is missing\"]}" }

      before do
        params.delete(key)
        post '/v1/users', params
      end

      it_behaves_like 'api/params_failure'
    end

    context 'invalid value' do
      let(:error_details) { "{:#{key}=>[\"must be a hash\"]}" }

      before do
        params[key] = nil
        post '/v1/users', params
      end

      it_behaves_like 'api/params_failure'
    end
  end
end
