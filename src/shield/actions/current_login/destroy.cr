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
          do_run_operation_failed(operation)
        end
      end
    end

    def login
      current_login!
    end

    def do_run_operation_succeeded(operation, login)
      flash.success = "You logged out"
      redirect to: New
    end

    def do_run_operation_failed(operation)
      flash.failure = "Something went wrong"
      redirect to: CurrentUser::Show
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
