module Shield::Api::CurrentUser::EmailConfirmations::Destroy
  macro included
    skip :require_logged_out

    # delete "/account/email-confirmations" do
    #   run_operation
    # end

    def run_operation
      EndCurrentUserEmailConfirmations.update(user) do |operation, updated_user|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_user)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    {% if Avram::Model.all_subclasses
      .map(&.stringify)
      .includes?("BearerLogin") %}

      def user
        current_user_or_bearer
      end
    {% else %}
      def user
        current_user
      end
    {% end %}

    def do_run_operation_succeeded(operation, user)
      json UserSerializer.new(
        user: user,
        message: Rex.t(
          :"action.current_user.email_confirmation.destroy.success"
        )
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(
          :"action.current_user.email_confirmation.destroy.failure"
        )
      )
    end

    def authorize?(user : Shield::User) : Bool
      user.id == self.user.id
    end
  end
end
