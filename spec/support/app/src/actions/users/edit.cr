class Users::Edit < BrowserAction
  skip :require_logged_out

  get "/users/:user_id/edit" do
    json({user: 1})
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("129.0.0.5", 6000)
  end
end
