module Shield::EmailConfirmations::Show
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

    before :set_no_referrer_policy # <= IMPORTANT!

    # param token : String

    # get "/email-confirmations" do
    #   run_operation
    # end

    def run_operation
      email_confirmation_session = EmailConfirmationSession.new(session)
      email_confirmation_session.set(token)

      redirect(email_confirmation_session) # <= IMPORTANT!
    end

    private def redirect(email_confirmation_session : EmailConfirmationSession)
      if email_confirmation_session.email_confirmation.try &.user_id
        redirect to: EmailConfirmations::Edit
      else
        redirect to: CurrentUser::New
      end
    end

    def authorize?(user : User) : Bool
      user.id == current_user.try &.id
    end
  end
end
