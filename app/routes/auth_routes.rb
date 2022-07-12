# frozen_string_literal: true

class AuthRoutes < Application
  post '/' do
    token = request.env['HTTP_AUTHORIZATION']
    operation = Users::AuthOperation.call(token: token)

    if operation.success?
      meta = { user_id: operation.user.id }

      status 200
      json meta: meta
    else
      status 403
      error_response(operation.errors)
    end
  end
end
