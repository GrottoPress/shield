module Shield::CurrentUser::Update
  macro included
    # patch "/profile" do
    #   authorize(:update, user) do
    #     save_current_user
    #   end
    # end

    def save_current_user
      UpdateCurrentUser.update(
        user,
        params,
        current_login: current_login
      ) do |operation, updated_user|
        if operation.saved?
          success_action(operation, updated_user)
        else
          failure_action(operation, updated_user)
        end
      end
    end

    def user
      current_user!
    end

    def success_action(operation, user)
      flash.success = "User updated successfully"
      redirect to: Show
    end

    def failure_action(operation, user)
      flash.failure = "Could not update user"
      html EditPage, operation: operation, user: user
    end
  end
end
