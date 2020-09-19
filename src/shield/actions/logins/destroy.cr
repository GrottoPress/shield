module Shield::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/log-out" do
    #   run_operation
    # end

    def run_operation
      LogUserOut.update(
        LoginSession.new(session).login!,
        session: session
      ) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          do_run_operation_failed(operation, updated_login)
        end
      end
    end

    def do_run_operation_succeeded(operation, login)
      flash.keep
      flash.info = "Logged out. See ya!"
      redirect to: New
    end

    def do_run_operation_failed(operation, login)
      flash.keep
      flash.failure = "Something went wrong"
      redirect to: CurrentUser::Show
    end

    def authorize? : Bool
      true
    end
  end
end
