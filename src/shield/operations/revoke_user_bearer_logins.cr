module Shield::RevokeUserBearerLogins
  macro included
    needs current_bearer_login : BearerLogin?

    after_save end_bearer_logins

    private def end_bearer_logins(user : Shield::User)
      query = BearerLoginQuery.new.user_id(user.id).is_active
      current_bearer_login.try { |login| query = query.id.not.eq(login.id) }

      {% if Avram::Model.all_subclasses
        .map(&.stringify)
        .includes?("OauthClient") %}

        query = query.oauth_client_id.is_nil
      {% end %}

      query.update(inactive_at: Time.utc)
    end
  end
end
