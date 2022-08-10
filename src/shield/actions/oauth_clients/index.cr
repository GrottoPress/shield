module Shield::OauthClients::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/oauth/clients" do
    #   html IndexPage, oauth_clients: oauth_clients, pages: pages
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
        .is_active
        .preload_user
        .active_at.desc_order
    end
  end
end
