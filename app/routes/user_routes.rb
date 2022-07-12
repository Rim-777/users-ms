# frozen_string_literal: true

class UserRoutes < Application
  helpers PaginationLinks

  namespace '/' do
    get do
      users = User.reverse_order(:updated_at)
      page_num = params[:page].presence || 1
      page_size = Settings.pagination.page_size
      paginated_ads = users.paginate(page_num, page_size)
      serializer = UserSerializer.new(paginated_ads.all, links: pagination_links(paginated_ads))

      json serializer.serializable_hash
    end

    post do
      user_params = validate_with!(params, UserCreateParamsContract)
      operation = Users::CreateOperation.call(
        user_params[:data][:attributes]
      )

      if operation.success?
        serializer = UserSerializer.new(operation.user)
        status 201
        json serializer.serializable_hash
      else
        status 422
        error_response(operation.user || operation.errors)
      end
    end
  end
end
