# frozen_string_literal: true

class UserSessionRoutes < Application
  namespace '/' do
    post do
      session_params = validate_with!(params, SessionCreateParamsContract)
      operation = UserSessions::CreateOperation.call(**session_params.to_h)

      if operation.success?
        meta = { token: operation.encrypted_token }

        status 201
        json meta: meta
      else
        status 401
        error_response(operation.session || operation.errors)
      end
    end
  end
end
