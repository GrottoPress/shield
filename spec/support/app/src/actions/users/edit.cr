class Users::Edit < BrowserAction
  include Shield::Users::Edit

  skip :check_authorization

  get "/users/:user_id/edit" do
    operation = UpdateUser.new(user, current_login: current_login)
    html EditPage, operation: operation
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("129.0.0.5", 6000)
  end
end
