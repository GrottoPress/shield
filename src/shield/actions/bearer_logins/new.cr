module Shield::BearerLogins::New
  macro included
    skip :require_logged_out

    # get "/bearer-logins/new" do
    #   operation = CreateBearerLogin.new(
    #     allowed_scopes: BearerScope.action_scopes.map(&.name)
    #   )
    #
    #   html NewPage, operation: operation
    # end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
