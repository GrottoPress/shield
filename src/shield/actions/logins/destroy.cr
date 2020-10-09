module Shield::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/login" do
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
      flash.keep.success = "Logged out. See ya!"
      redirect to: New
    end

    def do_run_operation_failed(operation, login)
      flash.keep.failure = "Something went wrong"
      redirect to: CurrentUser::Show
    end

    def authorize?(user : User) : Bool
      true
    end
  end
end
