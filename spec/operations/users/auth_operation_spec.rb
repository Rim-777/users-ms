# frozen_string_literal: true

RSpec.describe Users::AuthOperation do
  subject { described_class }

  def subject_call
    subject.call(params)
  end

  let!(:user) { create(:user) }
  let!(:session) { create(:user_session, user_id: user.id) }
  let(:token) { JwtEncoder.encode(uuid: session.uuid) }

  let(:params) do
    {
      token: "Bearer #{token}"
    }
  end

  context  'success' do
    it_behaves_like 'operations/success'

    it 'assigns user' do
      expect(subject_call.user).to eq(user)
    end
  end

  context 'failure' do
    context 'invalid token format' do
      let(:params) do
        {
          token: "Bear #{token}"
        }
      end

      let(:error_messages){["Invalid access token format"]}

      it_behaves_like 'operations/failure'
    end

    context 'token does not exist' do
      let(:token) { JwtEncoder.encode(uuid: '90a09e67-fc2a-4c14-adb1-0b210bc713f1') }
      let(:error_messages){["Missing session"]}

      it_behaves_like 'operations/failure'
    end
  end
end