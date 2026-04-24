module Shield::CurrentUser::OauthClients::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # param page : Int32 = 1

    # get "/account/oauth/clients" do
    #   html IndexPage, oauth_clients: oauth_clients, pages: pages
    # end

    def user
      current_user
    end

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
        .user_id(user.id)
        .is_active
        .active_at.desc_order
    end
  end
end
