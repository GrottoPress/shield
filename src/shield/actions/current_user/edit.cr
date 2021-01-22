module Shield::CurrentUser::Edit
  macro included
    skip :require_logged_out

    # get "/account/edit" do
    #   operation = UpdateCurrentUser.new(user, current_login: current_login)
    #   html EditPage, operation: operation
    # end

    def user
      current_user!
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
