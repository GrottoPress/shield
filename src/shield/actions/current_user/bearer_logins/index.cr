module Shield::CurrentUser::BearerLogins::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/account/bearer-logins" do
    #   html IndexPage, bearer_logins: bearer_logins, pages: pages
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
      {% if Avram::Model.all_subclasses.find(&.name.== :OauthClient.id) %}
        paginate BearerLoginQuery.new
          .user_id(user.id)
          .oauth_client_id.is_nil
          .is_active
          .active_at.desc_order
      {% else %}
        paginate BearerLoginQuery.new
          .user_id(user.id)
          .is_active
          .active_at.desc_order
      {% end %}
    end

    def user
      current_user
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
