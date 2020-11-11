class Users::Show < BrowserAction
  include Shield::Users::Show

  get "/users/:user_id" do
    json({user: user_id.to_i64})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
