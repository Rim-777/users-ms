# frozen_string_literal: true

shared_examples 'api/params_failure' do
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
