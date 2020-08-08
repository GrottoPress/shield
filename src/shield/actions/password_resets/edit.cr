module Shield::PasswordResets::Edit
  macro included
    skip :require_logged_in

    # get "/password-resets/edit" do
    #   run_operation
    # end

    def run_operation
      PasswordResetSession.new(session).verify do |utility, password_reset|
        if password_reset
          do_run_operation_succeeded(utility, password_reset.not_nil!)
        else
          do_run_operation_failed(utility)
        end
      end
    end

    def do_run_operation_succeeded(utility, password_reset)
      html EditPage
    end

    def do_run_operation_failed(utility)
      flash.failure = "Invalid token"
      redirect to: New
    end
  end
end
