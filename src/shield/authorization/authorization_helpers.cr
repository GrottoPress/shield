module Shield::AuthorizationHelpers
  macro included
    @authorized = false

    def authorize(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      authorize!(action, record) { yield }
    rescue error : Shield::NotAuthorizedError
      not_authorized_action(error.user, error.action, error.record)
    end

    def authorize!(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      @authorized = true

      if logged_out? || current_user!.can?(action, record)
        yield
      else
        raise Shield::NotAuthorizedError.new(current_user!, action, record)
      end
    end

    def not_authorized_action(user, action, record)
      flash.failure = "You are not allowed to perform this action!"
      redirect_back fallback: CurrentUser::Show
    end
  end
end
