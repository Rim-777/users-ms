# frozen_string_literal: true

module Users
  class CreateOperation
    prepend BaseOperation

    option :email, type: Dry::Types['strict.string']
    option :password, type: Dry::Types['strict.string']
    option :first_name, optional: true
    option :last_name, optional: true

    attr_reader :user

    def call
      check_email_existence
      create_user
    end

    private

    def check_email_existence
      return unless User.find(email: @email)

      interrupt_with_errors!([I18n.t(:taken, scope: 'model.errors.email')])
    end

    def create_user
      @user = User.new(attributes)
      if @user.valid?
        @user.save
      else
        fail!([@user.errors])
      end
    end

    def attributes
      {
        email: @email,
        password: @password,
        first_name: @first_name,
        last_name: @last_name
      }
    end
  end
end
