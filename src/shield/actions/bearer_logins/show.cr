module Shield::BearerLogins::Show
  macro included
    skip :require_logged_out

    # get "/bearer_logins/:bearer_login_id" do
    #   html ShowPage, bearer_login: bearer_login, token: token
    # end

    getter bearer_login : BearerLogin do
      BearerLoginQuery.find(bearer_login_id)
    end

    def token : String
      token?.not_nil!
    end

    getter? token : String? do
      BearerTokenSession.new(session).bearer_token?
    end
  end
end
