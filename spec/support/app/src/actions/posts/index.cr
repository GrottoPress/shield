class Posts::Index < BearerApiAction
  skip :require_logged_out

  get "/posts" do
    json({
      scopes: current_bearer_login.try &.scopes,
      current_bearer_user: current_bearer_user.try &.id,
      current_user: current_user.try &.id
    })
  end

  def authorize?(user : User) : Bool
    true
  end
end