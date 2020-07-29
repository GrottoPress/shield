class Users::Update < ApiAction
  include Shield::Users::Update

  skip :require_logged_in
  skip :require_authorization

  patch "/users/:user_id" do
    save_user
  end

  private def success_action(operation, user)
    json({user: user.id})
  end

  private def failure_action(operation, user)
    json({user: user.id, errors: operation.errors})
  end
end
