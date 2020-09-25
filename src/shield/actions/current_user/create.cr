module Shield::CurrentUser::Create
  # IMPORTANT!
  #
  # Prevent user enumeration by showing the same response
  # even if the email address is already registered.
  #
  # This assumes we're sending welcome emails.
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
      success_action
    end

    def do_run_operation_failed(operation)
      if operation.user_email?
        success_action # <= IMPORTANT!
      else
        flash.failure = "Could not create your account"
        html NewPage, operation: operation
      end
    end

    private def success_action
      flash.keep.success = "Done! Check your email for further instructions."
      redirect to: Logins::New
    end
  end
end
