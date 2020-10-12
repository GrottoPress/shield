class Posts::Create < BearerApiAction
  skip :require_logged_out

  post "/posts" do
    json({
      scopes: current_bearer_login.try &.scopes,
      current_bearer_user: current_bearer_user.try &.id,
      current_user: current_user.try &.id
    })
  end
end
