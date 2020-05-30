module Shield::CreateLogin
  macro included
    # post "/log-in" do
    #   log_user_in
    # end

    skip :require_logged_in
    before :require_logged_out

    private def log_user_in
      LogUserIn.create(
        params,
        session: session,
        cookies: cookies,
        ip_address: remote_ip
      ) do |operation, login|
        if login
          success_action(operation, login.not_nil!)
        else
          failure_action(operation)
        end
      end
    end

    private def success_action(operation, login)
      flash.success = "Successfully logged in"

      if dest = Login.return_path(session, delete: true)
        redirect to: dest
      else
        redirect to: Home::Index
      end
    end

    private def failure_action(operation)
      flash.failure = "Invalid email or password"
      html NewPage, operation: operation
    end
  end
end
