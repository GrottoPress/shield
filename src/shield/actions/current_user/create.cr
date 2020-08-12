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
      flash.success = "Congratulations! Log in to access your account..."
      redirect to: Logins::New
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not create your account"
      html NewPage, operation: operation
    end
  end
end
