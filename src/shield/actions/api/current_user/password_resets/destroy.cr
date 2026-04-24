module Shield::Api::CurrentUser::PasswordResets::Destroy
  macro included
    skip :require_logged_out

    authorize_user do |user|
      user.id == self.user.id
    end

    # delete "/account/password-resets" do
    #   run_operation
    # end

    def run_operation
      EndCurrentUserPasswordResets.update(user) do |operation, updated_user|
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
      json UserSerializer.new(
        user: user,
        message: Rex.t(:"action.current_user.password_reset.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.current_user.password_reset.destroy.failure")
      )
    end
  end
end
