module Shield::CurrentUser::Create
  macro included
    skip :require_logged_in

    # post "/register" do
    #   save_current_user
    # end

    def save_current_user
      RegisterCurrentUser.create(params) do |operation, user|
        if user
          success_action(operation, user.not_nil!)
        else
          failure_action(operation)
        end
      end
    end

    def success_action(operation, user)
      flash.success = "User added successfully"
      redirect to: New
    end

    def failure_action(operation)
      flash.failure = "Could not add user"
      html NewPage, operation: operation
    end
  end
end
