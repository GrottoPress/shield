module Shield::Api::CurrentUser::PasswordResets::Destroy
  macro included
    skip :require_logged_out

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
      {% if Avram::Model.all_subclasses.find(&.name.== :BearerLogin.id) %}
        current_user_or_bearer
      {% else %}
        current_user
      {% end %}
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

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
