module Shield::EditPasswordReset
  macro included
    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out

    # get "/password-resets/edit" do
    #   verify_password_reset
    # end

    private def verify_password_reset
      if password_reset = PasswordReset.from_session(session)
        success_action(password_reset.not_nil!)
      else
        failure_action
      end
    end

    private def success_action(password_reset)
      html EditPage
    end

    private def failure_action
      flash.failure = "Invalid token"
      redirect to: New
    end
  end
end
