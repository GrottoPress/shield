module Shield::BearerLogins::Show
  macro included
    skip :require_logged_out

    # get "/bearer-logins/:bearer_login_id" do
    #   html ShowPage, bearer_login: bearer_login
    # end

    getter bearer_login : BearerLogin do
      BearerLoginQuery.find(bearer_login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == bearer_login.user_id
    end
  end
end
