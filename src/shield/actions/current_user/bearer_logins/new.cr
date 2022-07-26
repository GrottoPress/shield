module Shield::CurrentUser::BearerLogins::New
  macro included
    skip :require_logged_out

    # get "/account/bearer-logins/new" do
    #   operation = CreateBearerLogin.new(user: user)
    #   html NewPage, operation: operation
    # end

    def user
      current_user
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
