class Api::Posts::Create < ApiAction
  skip :require_logged_out
  skip :pin_login_to_ip_address

  post "/posts" do
    json({
      scopes: current_bearer_login?.try &.scopes,
      current_bearer: current_bearer?.try &.id,
      current_user: current_user?.try &.id
    })
  end
end
