# frozen_string_literal: true

shared_examples 'api/attributes_key_failure' do
  context '#data/attributes' do
    context 'missing key' do
      let(:error_details) { '{:data=>{:attributes=>["is missing"]}}' }

      let(:params) do
        {
          data: {
            test: 'test' # this field is needed because of a bug
            # related to sinatra params, which come with missing
            # field if a value is empty todo remove it when the bug is fixed
          }
        }
      end

      before do
        perform_request(params)
      end

      it_behaves_like 'api/params_failure'
    end

    context 'invalid value' do
      let(:error_details) { '{:data=>{:attributes=>["must be a hash"]}}' }

      before do
        params[:data][:attributes] = nil
        perform_request(params)
      end

      it_behaves_like 'api/params_failure'
    end
  end
end
