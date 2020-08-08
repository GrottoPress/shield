class Users::Edit < ApiAction
  include Shield::Users::Edit

  get "/users/:user_id/edit" do
    json({user: user.id})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("127.0.0.1", 6000)
  end
end
