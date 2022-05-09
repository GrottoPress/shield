module Shield::Api::BearerLogins::Show
  macro included
    skip :require_logged_out

    # get "/bearer_logins/:bearer_login_id" do
    #   json BearerLoginSerializer.new(bearer_login: bearer_login)
    # end

    getter bearer_login : BearerLogin do
      BearerLoginQuery.find(bearer_login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == bearer_login.user_id
    end
  end
end
