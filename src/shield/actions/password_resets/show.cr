module Shield::PasswordResets::Show
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

    before :set_no_referrer_policy # <= IMPORTANT!

    # param id : Int64
    # param token : String

    # get "/password-resets" do
    #   run_operation
    # end

    def run_operation
      PasswordResetSession.new(session).set(id, token)
      redirect to: Edit # <= IMPORTANT!
    end
  end
end
