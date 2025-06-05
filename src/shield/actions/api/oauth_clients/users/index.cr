module Shield::Api::OauthClients::Users::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/oauth/clients/:oauth_client_id/users" do
    #   json UserSerializer.new(
    #     users: users,
    #     oauth_client: oauth_client,
    #     pages: pages
    #   )
    # end

    getter oauth_client : OauthClient do
      OauthClientQuery.find(oauth_client_id)
    end

    def pages
      paginated_users[0]
    end

    getter users : Array(User) do
      paginated_users[1].results
    end

    private getter paginated_users : Tuple(
      Lucky::Paginator,
      UserQuery
    ) do
      {% begin %}
        paginate UserQuery.new
          {% if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
            .join_bearer_logins(BearerLoginQuery.new
          {% else %}
            .where_bearer_logins(BearerLoginQuery.new
          {% end %}
          .oauth_client_id(oauth_client_id)
          .is_active
          .active_at.desc_order
        )
      {% end %}
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == oauth_client.user_id
    end
  end
end
