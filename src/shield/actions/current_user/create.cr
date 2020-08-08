module Shield::CurrentUser::Create
  macro included
    skip :require_logged_in

    # post "/register" do
    #   run_operation
    # end

    def run_operation
      RegisterCurrentUser.create(params) do |operation, user|
        if user
          do_run_operation_succeeded(operation, user.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = "User added successfully"
      redirect to: New
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not add user"
      html NewPage, operation: operation
    end
  end
end
