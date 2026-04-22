class Api::Posts::Index < ApiAction
  skip :require_logged_out

  authorize { true }

  get "/posts" do
    json({
      scopes: current_bearer_login?.try &.scopes,
      current_bearer: current_bearer?.try &.id,
      current_user: current_user?.try &.id
    })
  end

  def remote_ip? : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
