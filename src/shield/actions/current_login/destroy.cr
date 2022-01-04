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
      current_login
    end

    def do_run_operation_succeeded(operation, login)
      flash.success = Rex.t(:"action.current_login.destroy.success")
      redirect to: New
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_login.destroy.failure")
      redirect_back fallback: CurrentUser::Show
    end

    def authorize?(user : Shield::User) : Bool
      user.id == login.user_id
    end
  end
end
