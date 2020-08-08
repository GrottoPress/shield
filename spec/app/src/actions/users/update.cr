class Users::Update < ApiAction
  include Shield::Users::Update

  skip :require_logged_in
  skip :require_logged_out

  patch "/users/:user_id" do
    save_user
  end

  def success_action(operation, user)
    json({user: user.id})
  end

  def failure_action(operation, user)
    json({user: user.id, errors: operation.errors})
  end
end
