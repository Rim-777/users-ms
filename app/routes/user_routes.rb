class UsersRoutes < Application
  helpers PaginationLinks

  namespace '/v1/users' do
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
      operation = Ads::CreateOperation.call(
        ad: ad_params[:ad],
        user_id_ref: params[:user_id_ref]
      )

      if operation.success?
        serializer = AdSerializer.new(operation.ad)
        status 201
        json serializer.serializable_hash
      else
        status 422
        error_response(operation.ad)
      end
    end
  end
end
