# frozen_string_literal: true

RSpec.describe Users::CreateOperation do
  subject { described_class }

  def subject_call
    subject.call(params)
  end

  let(:params) do
    {
      email: 'test@email.com',
      password: '12234567',
      first_name: 'John',
      last_name: 'Boy'
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

      it 'creates a new ad' do
        expect { subject_call }
          .to change { User.count }.from(0).to(1)
      end

      it 'assigns user' do
        expect(subject_call.user).to be_kind_of(User)
      end
    end

    context 'all attributes' do
      include_examples :success

      it 'assigns attributes' do
        expect(subject_call.user)
          .to have_attributes(
            email: params.fetch(:email),
            first_name: params.fetch(:first_name),
            last_name: params.fetch(:last_name)
          )
      end
    end

    context 'only required attributes' do
      before do
        params[:first_name] = nil
        params.delete(:last_name)
      end

      include_examples :success

      it 'assigns attributes' do
        expect(subject_call.user)
          .to have_attributes(
            email: params.fetch(:email),
            first_name: nil,
            last_name: nil
          )
      end
    end
  end

  context 'invalid parameters' do
    shared_examples :failure do
      it 'looks like failure' do
        expect(subject_call).to be_failure
      end

      it 'contains errors' do
        expect(subject_call.errors).to eq(error_messages)
      end

      it 'does not create user' do
        expect { subject_call }
          .not_to change { User.count }
      end
    end

    context 'email' do
      context 'nil' do
        before do
          params[:email] = nil
        end

        let(:error_messages) do
          [{ email: ['Cannot be blank'] }]
        end

        include_examples :failure
      end
      context 'invalid format' do
        before do
          params[:email] = 'test@test'
        end

        let(:error_messages) do
          [{ email: ['Invalid format'] }]
        end

        include_examples :failure
      end
    end
    context 'password' do
      context 'nil' do
        before do
          params[:password] = nil
        end

        let(:error_messages) do
          [{ password: ['Cannot be blank'] }]
        end

        include_examples :failure
      end
    end

    context 'first_name, last_name' do
      context 'invalid format' do
        before do
          params[:first_name] = '123'
          params[:last_name] = 'Ludovic 16'
        end

        let(:error_messages) do
          [{ first_name: ['Can contain only letters'], last_name: ['Can contain only letters'] }]
        end

        include_examples :failure
      end
    end
  end
end
