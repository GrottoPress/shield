module Shield::CreateCurrentUser
  macro included
    # post "/register" do
    #   add_current_user
    # end

    skip :require_logged_in
    before :require_logged_out

    private def add_current_user
      SaveCurrentUser.create(params) do |operation, user|
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
      html NewPage, save_user: operation
    end
  end
end
