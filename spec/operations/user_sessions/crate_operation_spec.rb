# frozen_string_literal: true

RSpec.describe UserSessions::CreateOperation do
  subject { described_class }

  def subject_call
    subject.call(params)
  end

  let(:email) { 'test@email.com' }
  let(:password) { '12234567' }
  let!(:user) { create(:user, email: email, password: password) }

  let(:params) do
    {
      email: email,
      password: password
    }
  end

  context 'valid parameters' do
    it_behaves_like 'operations/success'

    it 'creates a new user session' do
      expect { subject_call }
        .to change { UserSession.count }.from(0).to(1)
    end

    it 'creates a new user session' do
      expect do
        subject_call
        user.reload
      end
        .to change { user.sessions.count }.from(0).to(1)
    end

    it 'assigns a created session' do
      expect(subject_call.session).to be_kind_of(UserSession)
    end
  end

  context 'invalid parameters' do
    shared_examples :failure do
      it_behaves_like 'operations/failure'

      it 'does not create user session' do
        expect { subject_call }
          .not_to change { UserSession.count }
      end

      it 'does not assign session' do
        expect(subject_call.session).to be_nil
      end
    end

    context 'email' do
      before do
        params[:email] = 'another@email.com'
      end

      let(:error_messages) do
        ['User not found']
      end

      include_examples :failure
    end

    context 'password' do
      before do
        params[:password] = 'invalid'
      end

      let(:error_messages) do
        ['Password does not match email']
      end

      include_examples :failure
    end
  end
end
