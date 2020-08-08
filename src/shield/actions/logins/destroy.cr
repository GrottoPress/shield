module Shield::Logins::Destroy
  macro included
    skip :require_logged_out

    # delete "/log-out" do
    #   log_user_out
    # end

    def log_user_out
      LogUserOut.update(
        LoginSession.new(session).login!,
        session: session
      ) do |operation, updated_login|
        if operation.saved?
          success_action(operation, updated_login)
        else
          failure_action(operation, updated_login)
        end
      end
    end

    def success_action(operation, login)
      flash.info = "Logged out. See ya!"
      redirect to: New
    end

    def failure_action(operation, login)
      flash.failure = "Something went wrong"
      redirect to: CurrentUser::Show
    end

    def authorize? : Bool
      true
    end
  end
end
