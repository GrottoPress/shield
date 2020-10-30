module Shield::BearerLogins::New
  macro included
    skip :require_logged_out

    # get "/bearer-logins/new" do
    #   operation = CreateBearerLogin.new(
    #     params,
    #     all_scopes: BearereLoginHelper.all_scopes
    #   )
    #
    #   html NewPage, operation: operation
    # end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
