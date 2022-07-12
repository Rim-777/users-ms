# frozen_string_literal: true

module Users
  class AuthOperation
    prepend BaseOperation

    option :token

    attr_reader :user

    def call
      match_token
      extract_token
      find_session
      set_user
    end

    private

    def match_token
      result = @token&.match(RegExp::BEARER_TOKEN)

      if result
        @matched_token = result[:token]
      else
        interrupt_with_errors!([I18n.t(:invalid_access_token_format, scope: 'api.errors')])
      end
    end

    def extract_token
      @extracted_token = JwtEncoder.decode(@matched_token)
    rescue JWT::DecodeError => e
      interrupt_with_errors!([e.message])
    end

    def find_session
      @session = UserSession.find(uuid: @extracted_token.fetch("uuid"))
      return if @session
      interrupt_with_errors!([I18n.t(:missing_session, scope: 'api.errors')])
    end

    def set_user
      @user = @session.user
      return if user
      interrupt_with_errors!([I18n.t(:missing_session_user, scope: 'api.errors')])
    end
  end
end
