module Shield::UpdatePasswordReset
  macro included
    skip :require_logged_in
    before :require_logged_out

    # patch "/password-resets" do
    #   reset_password
    # end

    private def reset_password
      password_reset = PasswordReset.from_session!(session, delete: true)

      ResetPassword.update(
        password_reset.user,
        params,
        password_reset: password_reset
      ) do |operation, updated_user|
        if operation.saved?
          success_action(operation, updated_user)
        else
          failure_action(operation, updated_user)
        end
      end
    end

    private def success_action(operation, user)
      flash.success = "Password changed successfully"
      redirect to: Logins::New
    end

    private def failure_action(operation, user)
      flash.failure = "Could not change password"
      html EditPage, reset_password: operation
    end
  end
end
