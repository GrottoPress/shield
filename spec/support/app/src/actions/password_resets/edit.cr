class PasswordResets::Edit < BrowserAction
  include Shield::PasswordResets::Edit

  get "/password-resets/edit" do
    run_operation
  end

  def remote_ip : Socket::IPAddress?
    Socket::IPAddress.new("128.0.0.2", 5000)
  end
end
