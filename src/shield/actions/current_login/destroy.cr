module Shield::CurrentLogin::Destroy
  macro included
    skip :require_logged_out

    # delete "/login" do
    #   run_operation
    # end

    def run_operation
      LogUserOut.update(login, session: session) do |operation, updated_login|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_login)
        else
          do_run_operation_failed(operation, updated_login)
        end
      end
    end

    @[Memoize]
    def login
      LoginSession.new(session).login!
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
      user.id == current_user.try &.id
    end
  end
end
