module Shield::AuthorizationPipes
  macro included
    before :check_authorization

    def check_authorization
      if logged_out? || authorize?(current_user)
        continue
      else
        response.status_code = 403
        do_check_authorization_failed
      end
    end

    def authorize?(user : Shield::User) : Bool
      false
    end

    def do_check_authorization_failed
      flash.failure = Rex.t(:"action.pipe.authorization_failed")
      redirect_back fallback: CurrentUser::Show
    end
  end
end
