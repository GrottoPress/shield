module Shield::Api::CurrentUser::Show
  macro included
    skip :require_logged_out

    # get "/account" do
    #   json UserSerializer.new(user: user)
    # end

    def user
      current_user_or_bearer
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
