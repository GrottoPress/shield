module Shield::BearerLogins::New
  macro included
    skip :require_logged_out

    # get "/bearer-logins/new" do
    #   operation = CreateBearerLogin.new(
    #     user: user,
    #     allowed_scopes: BearerScope.action_scopes.map(&.name)
    #   )
    #
    #   html NewPage, operation: operation
    # end

    def user
      current_user
    end

    def authorize?(user : User) : Bool
      user.id == self.user.id
    end
  end
end
