module Shield::IndexPasswordReset
  # SECURITY!
  #
  # Ensure tokens are not leaked in HTTP Referer header
  #
  # REFERENCES:
  #
  # - https://developer.mozilla.org/en-US/docs/Web/Security/Referer_header:_privacy_and_security_concerns
  # - https://twitter.com/HusseiN98D/status/1254888748216655872
  # - https://github.com/thoughtbot/clearance/pull/707
  macro included
    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out
    before :set_no_referrer_policy # <= SECURITY!

    # param id : Int64
    # param token : String

    # get "/password-resets" do
    #   authenticate
    # end

    private def authenticate
      if password_reset = PasswordReset.authenticate(id, token)
        success_action(password_reset.not_nil!)
      else
        failure_action
      end
    end

    private def success_action(password_reset)
      password_reset.set_session(session)
      redirect to: Edit # <= SECURITY!
    end

    private def failure_action
      flash.failure = "Invalid token"
      redirect to: New
    end
  end
end
