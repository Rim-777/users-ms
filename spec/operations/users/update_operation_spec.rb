# frozen_string_literal: true

RSpec.describe Users::UpdateOperation do
  subject { described_class }

  def subject_call
    subject.call(params)
  end

  let!(:user) do
    create(
      :user,
      email: 'test@email.com',
      password: '12234567',
      first_name: 'John',
      last_name: 'Boy'
    )
  end

  let(:params) do
    {
      user_id: user.id,
      email: 'timo@email.com',
      password: '12234567',
      first_name: 'Timo',
      last_name: 'Moss'
    }
  end

  context 'valid parameters' do
    shared_examples :success do
      it 'looks like success' do
        expect(subject_call).to be_success
      end

      it 'has no errors' do
        expect(subject_call.errors).to be_empty
      end

      it 'assigns user' do
        operation_user = subject_call.user
        user.reload
        expect(operation_user).to eq(user)
      end
    end

    context 'all attributes' do
      include_examples :success
      it 'updates an user email' do
        expect do
          subject_call
          user.reload
        end.to change { user.first_name }.from('John').to(params[:first_name])
      end

      it 'updates a last_name' do
        expect do
          subject_call
          user.reload
        end.to change { user.last_name }.from('Boy').to(params[:last_name])
      end

      it 'updates an email' do
        expect do
          subject_call
          user.reload
        end.to change { user.email }.from('test@email.com').to(params[:email])
      end

      it 'updates a user password' do
        subject_call
        user.reload
        expect(user.authenticate(params[:password])).to eq(user)
      end
    end

    context 'no attributes' do
      let(:params) do
        {
          user_id: user.id
        }
      end

      include_examples :success

      it 'does not change the user attributes' do
        expect do
          subject_call
          user.reload
        end.not_to change { user }
      end
    end
  end

  context 'failure' do
    context  'user not found' do
      before do
        params[:user_id] = 123_412_349_821_349_823_498
      end

      it 'looks like failure' do
        expect(subject_call).to be_failure
      end

      it 'has errors' do
        expect(subject_call.errors).to eq(['User not found'])
      end
    end
  end
end
