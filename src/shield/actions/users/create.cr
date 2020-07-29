module Shield::Users::Create
  macro included
    # post "/users" do
    #   authorize(:create, user)
    #   save_user
    # end

    private def save_user
      RegisterUser.create(params) do |operation, user|
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
