module Shield::LoginsEverywhere::Destroy
  macro included
    skip :require_logged_out

    # delete "/login/all" do
    #   run_operation
    # end

    def run_operation
      LogOutEverywhere.update(
        login,
        skip_current: true
      ) do |operation, updated_login|
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
      flash.success = Rex.t(:"action.login_everywhere.destroy.success")
      redirect_back fallback: CurrentUser::Show
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.login_everywhere.destroy.failure")
      redirect_back fallback: CurrentUser::Show
    end

    def authorize?(user : Shield::User) : Bool
      user.id == login.user_id
    end
  end
end
