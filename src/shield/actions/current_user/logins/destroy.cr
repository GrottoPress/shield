module Shield::CurrentUser::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/account/logins" do
    #   run_operation
    # end

    def run_operation
      EndCurrentUserLogins.update(
        user,
        current_login: current_login?
      ) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def user
      current_user
    end

    def do_run_operation_succeeded(operation, user)
      flash.success = Rex.t(:"action.current_user.login.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.current_user.login.destroy.failure")
      redirect_back fallback: Index
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
