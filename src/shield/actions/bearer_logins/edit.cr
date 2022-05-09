module Shield::BearerLogins::Edit
  macro included
    skip :require_logged_out

    # get "/bearer-logins/:bearer_login_id/edit" do
    #   operation = UpdateBearerLogin.new(bearer_login)
    #   html EditPage, operation: operation
    # end

    def bearer_login : BearerLogin
      BearerLoginQuery.find(bearer_login_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == bearer_login.user_id
    end
  end
end
