module Shield::PasswordResets::Update
  macro included
    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out

    # patch "/password-resets" do
    #   reset_password
    # end

    def reset_password
      PasswordResetSession.new(session).verify do |utility, password_reset|
        if password_reset
          reset_password(password_reset.not_nil!)
        else
          Edit.new(context, Hash(String, String).new).failure_action(utility)
        end
      end
    end

    private def reset_password(password_reset)
      ResetPassword.update(
        password_reset.user!,
        params,
        session: session,
        current_login: current_login
      ) do |operation, updated_user|
        if operation.saved?
          success_action(operation, updated_user)
        else
          failure_action(operation, updated_user)
        end
      end
    end

    def success_action(operation, user)
      flash.success = "Password changed successfully"
      redirect to: Logins::New
    end

    def failure_action(operation, user)
      flash.failure = "Could not change password"
      html EditPage, operation: operation, user: user
    end
  end
end
