# frozen_string_literal: true

shared_examples 'operations/success' do
  it 'looks like success' do
    expect(subject_call).to be_success
  end

  it 'has no errors' do
    expect(subject_call.errors).to be_empty
  end
end
