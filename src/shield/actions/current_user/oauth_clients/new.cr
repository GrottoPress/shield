module Shield::CurrentUser::OauthClients::New
  macro included
    skip :require_logged_out

    # get "/account/oauth/clients/new" do
    #   operation = RegisterOauthClient.new(user: user)
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
