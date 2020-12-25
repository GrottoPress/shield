class Users::Show < BrowserAction
  include Shield::Users::Show

  skip :check_authorization

  get "/users/:user_id" do
    html ShowPage, user: user
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
