class Users::Show < ApiAction
  include Shield::Users::Show

  get "/users/:user_id" do
    json({user: user.id})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
