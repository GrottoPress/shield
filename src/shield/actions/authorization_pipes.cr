module Shield::AuthorizationPipes
  macro included
    before :check_authorization

    def check_authorization
      if logged_out? || authorize?(current_user!)
        continue
      else
        response.status_code = 403
        do_check_authorization_failed
      end
    end

    def authorize?(user : User) : Bool
      false
    end

    def do_check_authorization_failed
      flash.keep.failure = "You are not allowed to perform this action!"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
