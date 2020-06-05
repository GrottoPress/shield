class CurrentUser::Create < ApiAction
  include Shield::CreateCurrentUser

  post "/register" do
    save_current_user
  end

  private def success_action(operation, user)
    json({user: user.id})
  end

  private def failure_action(operation)
    json({errors: operation.errors})
  end
end
