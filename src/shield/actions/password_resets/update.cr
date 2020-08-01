module Shield::PasswordResets::Update
  macro included
    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out

    # patch "/password-resets" do
    #   reset_password
    # end

    private def reset_password
      verify_password_reset = VerifyPasswordReset.new(params, session: session)
      password_reset = verify_password_reset.submit!

      ResetPassword.update(
        password_reset.user!,
        params,
        password_reset: password_reset,
        current_login: current_login
      ) do |operation, updated_user|
        if operation.saved?
          # TODO: Move this into `Shield::ResetPassword`?
          #       Tried it once, but it complicated the whole thing
          verify_password_reset.delete_session
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
      html EditPage, operation: operation, user: user
    end
  end
end
