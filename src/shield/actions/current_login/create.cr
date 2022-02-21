module Shield::CurrentLogin::Create
  macro included
    skip :require_logged_in

    # post "/login" do
    #   run_operation
    # end

    def run_operation
      StartCurrentLogin.create(
        params,
        session: session,
        remote_ip: remote_ip?
      ) do |operation, login|
        if operation.saved?
          do_run_operation_succeeded(operation, login.not_nil!)
        else
          response.status_code = 403
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, login)
      flash.success = Rex.t(:"action.current_login.create.success")
      redirect_back fallback: CurrentUser::Show
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_login.create.failure")
      html NewPage, operation: operation
    end
  end
end
