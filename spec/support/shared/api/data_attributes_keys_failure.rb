# frozen_string_literal: true

shared_examples 'api/data_root_key_failure' do
  it_behaves_like 'api/data_key_failure'

  it_behaves_like 'api/attributes_key_failure'
end
