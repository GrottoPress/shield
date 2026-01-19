module Shield::Api::BearerLogins::Show
  macro included
    skip :require_logged_out

    authorize do |user|
      super || user.id == bearer_login.user_id
    end

    # get "/bearer-logins/:bearer_login_id" do
    #   json BearerLoginSerializer.new(bearer_login: bearer_login)
    # end

    getter bearer_login : BearerLogin do
      BearerLoginQuery.find(bearer_login_id)
    end
  end
end
