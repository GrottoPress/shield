class PasswordResets::New < BrowserAction
  include Shield::PasswordResets::New

  get "/password-resets/new" do
    operation = StartPasswordReset.new(remote_ip: remote_ip)
    html NewPage, operation: operation
  end
end
