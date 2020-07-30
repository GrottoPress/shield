module Shield::CurrentUser::Update
  macro included
    # patch "/profile" do
    #   authorize(:update, user) do
    #     save_current_user
    #   end
    # end

    private def save_current_user
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

    private def user
      current_user!
    end

    private def success_action(operation, user)
      flash.success = "User updated successfully"
      redirect to: Show
    end

    private def failure_action(operation, user)
      flash.failure = "Could not update user"
      html EditPage, operation: operation, user: user
    end
  end
end
