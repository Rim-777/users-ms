# frozen_string_literal: true

module Users
  class UpdateOperation
    prepend BaseOperation

    option :user_id, type: Dry::Types['strict.integer']
    option :email, type: Dry::Types['strict.string'], optional: true
    option :password, type: Dry::Types['strict.string'], optional: true
    option :first_name, type: Dry::Types['strict.string'], optional: true
    option :last_name, type: Dry::Types['strict.string'], optional: true

    attr_reader :user

    def call
      set_user
      create_user
    end

    private

    def set_user
      @user = User.find(id: @user_id)
      return if @user

      interrupt_with_errors!([I18n.t(:not_found, scope: 'model.errors')])
    end

    def update_user
      @user.update(attributes)
      if @user.valid?
        @user.save
      else
        fail!([@user.errors])
      end
    end

    def attributes
      result = {}
      result[:email] = @email if @email
      result[:password] = @password if @password
      result[:first_name] = @first_name if @first_name
      result[:last_name] = @last_name if @last_name
      result
    end
  end
end
