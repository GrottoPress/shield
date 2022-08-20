module Shield::EmailConfirmations::Token::Show
  # IMPORTANT!
  #
  # Ensure tokens are not leaked in HTTP Referer header
  #
  # REFERENCES:
  #
  # - https://developer.mozilla.org/en-US/docs/Web/Security/Referer_header:_privacy_and_security_concerns
  # - https://twitter.com/HusseiN98D/status/1254888748216655872
  # - https://github.com/thoughtbot/clearance/pull/707
  macro included
    skip :require_logged_in
    skip :require_logged_out
    skip :check_authorization

    before :set_no_referrer_policy # <= IMPORTANT!

    # get "/email-confirmations/token/:token" do
    #   run_operation
    # end

    def run_operation
      email_confirmation_session = EmailConfirmationSession.new(session)
      email_confirmation_session.set(token)

      redirect(email_confirmation_session) # <= IMPORTANT!
    end

    private def redirect(email_confirmation_session)
      if email_confirmation_session.email_confirmation.try &.user_id
        redirect to: EmailConfirmations::Update
      else
        redirect to: CurrentUser::New
      end
    end
  end
end
