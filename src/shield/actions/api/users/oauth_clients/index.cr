module Shield::Api::Users::OauthClients::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/users/:user_id/oauth/clients" do
    #   json OauthClientSerializer.new(
    #     oauth_clients: oauth_clients,
    #     user: user,
    #     pages: pages
    #   )
    # end

    def pages
      paginated_oauth_clients[0]
    end

    getter oauth_clients : Array(OauthClient) do
      paginated_oauth_clients[1].results
    end

    private getter paginated_oauth_clients : Tuple(
      Lucky::Paginator,
      OauthClientQuery
    ) do
      paginate OauthClientQuery.new
        .user_id(user_id)
        .is_active
        .active_at.desc_order
    end

    getter user : User do
      UserQuery.find(user_id)
    end
  end
end
