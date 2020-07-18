module Shield::AuthorizationHelpers
  macro included
    @authorized = false

    private def authorize(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      authorize!(action, record)
    rescue error : Shield::NotAuthorizedError
      not_authorized_action(error.user, error.action, error.record)
    end

    private def authorize!(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      @authorized = true
      return if logged_out?

      unless current_user!.can?(action, record)
        raise Shield::NotAuthorizedError.new(current_user!, action, record)
      end
    end

    private def not_authorized_action(user, action, record)
      flash.failure = "You are not allowed to perform this action!"
      redirect to: CurrentUser::Show
    end
  end
end
