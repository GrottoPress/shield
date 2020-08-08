module Shield::PasswordResets::Edit
  macro included
    skip :require_logged_in

    # get "/password-resets/edit" do
    #   verify_password_reset
    # end

    def verify_password_reset
      PasswordResetSession.new(session).verify do |utility, password_reset|
        if password_reset
          success_action(utility, password_reset.not_nil!)
        else
          failure_action(utility)
        end
      end
    end

    def success_action(utility, password_reset)
      html EditPage
    end

    def failure_action(utility)
      flash.failure = "Invalid token"
      redirect to: New
    end
  end
end
