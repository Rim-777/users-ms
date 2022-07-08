# frozen_string_literal: true

module UserSessions
  class CreateOperation
    prepend BaseOperation

    option :email
    option :password

    attr_reader :session

    def call
      set_user
      validate_password
      create_session
    end

    private

    def set_user
      @user = User.find(email: @email)
      return if @user

      interrupt_with_errors!([I18n.t(:not_found, scope: 'model.errors', record: 'User')])
    end

    def validate_password
      return if @user.authenticate(@password)

      interrupt_with_errors!([I18n.t(:invalid_credentials, scope: 'api.errors')])
    end

    def create_session
      @session = UserSession.new

      if @session.valid?
        @user.add_session(@session)
      else
        fail!(@session.errors)
      end
    end
  end
end
