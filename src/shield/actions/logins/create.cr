module Shield::Logins::Create
  macro included
    skip :require_logged_in

    # post "/log-in" do
    #   run_operation
    # end

    def run_operation
      LogUserIn.create(
        params,
        session: session,
        remote_ip: remote_ip
      ) do |operation, login|
        if login
          do_run_operation_succeeded(operation, login.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, login)
      flash.keep
      flash.success = "Successfully logged in"
      redirect_back fallback: CurrentUser::Show
    end

    def do_run_operation_failed(operation)
      flash.failure = "Invalid email or password"
      html NewPage, operation: operation
    end
  end
end
