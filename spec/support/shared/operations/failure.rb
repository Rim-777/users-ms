# frozen_string_literal: true

shared_examples 'operations/failure' do
  it 'looks like failure' do
    expect(subject_call).to be_failure
  end

  it 'contains errors' do
    expect(subject_call.errors).to eq(error_messages)
  end
end
