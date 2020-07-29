module Shield::CurrentUser::Create
  macro included
    # post "/register" do
    #   save_current_user
    # end

    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out

    private def save_current_user
      RegisterCurrentUser.create(params) do |operation, user|
        if user
          success_action(operation, user.not_nil!)
        else
          failure_action(operation)
        end
      end
    end

    private def success_action(operation, user)
      flash.success = "User added successfully"
      redirect to: New
    end

    private def failure_action(operation)
      flash.failure = "Could not add user"
      html NewPage, operation: operation
    end
  end
end
