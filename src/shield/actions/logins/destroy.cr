module Shield::Logins::Destroy
  macro included
    # delete "/log-out" do
    #   log_user_out
    # end

    private def log_user_out
      LogUserOut.update(
        VerifyLogin.new(params, session: session).login!,
        session: session
      ) do |operation, updated_login|
        if operation.saved?
          success_action(operation, updated_login)
        else
          failure_action(operation, updated_login)
        end
      end
    end

    private def success_action(operation, login)
      flash.info = "Logged out. See ya!"
      redirect to: New
    end

    private def failure_action(operation, login)
      flash.failure = "Something went wrong"
      redirect to: CurrentUser::Show
    end
  end
end
