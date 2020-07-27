module Shield::EditPasswordReset
  macro included
    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out

    # get "/password-resets/edit" do
    #   verify_password_reset
    # end

    private def verify_password_reset
      VerifyPasswordReset.new(
        params,
        session: session
      ).submit do |operation, password_reset|
        if password_reset &&= password_reset.not_nil!
          success_action(operation, password_reset)
        else
          failure_action(operation)
        end
      end
    end

    private def success_action(operation, password_reset)
      html EditPage
    end

    private def failure_action(operation)
      flash.failure = "Invalid token"
      redirect to: New
    end
  end
end
