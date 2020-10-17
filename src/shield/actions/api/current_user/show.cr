module Shield::Api::CurrentUser::Show
  macro included
    skip :require_logged_out

    # get "/account" do
    #   json({
    #     status: "success",
    #     data: {user: UserSerializer.new(user)}
    #   })
    # end

    def user
      current_or_bearer_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_or_bearer_user.try &.id
    end
  end
end
