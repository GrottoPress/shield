module Shield::Api::CurrentUser::OauthPermissions::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/oauth/permissions" do
    #   json OauthClientSerializer.new(oauth_clients: oauth_clients, pages: pages)
    # end

    def user
      current_user_or_bearer
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
      {% begin %}
        paginate OauthClientQuery.new
          {% if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
            .join_bearer_logins(BearerLoginQuery.new
          {% else %}
            .where_bearer_logins(BearerLoginQuery.new
          {% end %}
            .user_id(user.id)
            .is_active
            .active_at.desc_order
          )
      {% end %}
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
