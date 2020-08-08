module Shield::AuthorizationPipes
  macro included
    def check_authorization
      if logged_out? || authorize?
        continue
      else
        not_authorized_action
      end
    end

    def authorize? : Bool
      false
    end

    def not_authorized_action
      flash.failure = "You are not allowed to perform this action!"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
