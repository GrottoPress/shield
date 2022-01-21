class Api::Posts::New < ApiAction
  skip :require_logged_in

  get "/posts/new" do
    json({
      scopes: current_bearer_login?.try &.scopes,
      current_bearer: current_bearer?.try &.id,
      current_user: current_user?.try &.id
    })
  end

  def authorize?(user : User) : Bool
    true
  end
end
