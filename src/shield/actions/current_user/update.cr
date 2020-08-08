module Shield::CurrentUser::Update
  macro included
    skip :require_logged_out

    # patch "/profile" do
    #   save_current_user
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

    def authorize? : Bool
      true
    end
  end
end
