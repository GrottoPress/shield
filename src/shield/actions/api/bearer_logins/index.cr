module Shield::Api::BearerLogins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   json BearerLoginSerializer.new(bearer_logins: bearer_logins, pages: pages)
    # end

    def pages
      paginated_bearer_logins[0]
    end

    getter bearer_logins : Array(BearerLogin) do
      paginated_bearer_logins[1].results
    end

    private getter paginated_bearer_logins : Tuple(
      Lucky::Paginator,
      BearerLoginQuery
    ) do
      {% if Avram::Model.all_subclasses
        .map(&.stringify)
        .includes?("OauthClient") %}

        paginate BearerLoginQuery.new
          .oauth_client_id.is_nil
          .is_active
          .preload_user
          .active_at.desc_order
      {% else %}
        paginate BearerLoginQuery.new
          .is_active
          .preload_user
          .active_at.desc_order
      {% end %}
    end
  end
end
