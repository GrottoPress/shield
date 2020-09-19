module Shield::AuthorizationPipes
  macro included
    def check_authorization
      if logged_out? || authorize?
        continue
      else
        do_check_authorization_failed
      end
    end

    def authorize? : Bool
      false
    end

    def do_check_authorization_failed
      flash.keep
      flash.failure = "You are not allowed to perform this action!"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
