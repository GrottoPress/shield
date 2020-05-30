module Shield::AuthorizationHelpers
  macro included
    @authorized = false

    private def authorize(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      authorize(current_user, action, record)
    end

    private def authorize!(
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      authorize!(current_user, action, record)
    end

    private def authorize(
      user : Shield::User?,
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      authorize!(user, action, record)
    rescue error : Shield::NotAuthorizedError
      notauthorized_action(error.user, error.action, error.record)
    end

    private def authorize!(
      user : Shield::User?,
      action : Shield::AuthorizedAction,
      record : Shield::Model | Shield::Model.class
    )
      @authorized = true

      if user
        unless user.not_nil!.can?(action, record)
          raise Shield::NotAuthorizedError.new(user, action, record)
        end
      end
    end

    private def notauthorized_action(user, action, record)
      flash.failure = "You are not allowed to perform this action!"
      redirect to: Home::Index
    end
  end
end
