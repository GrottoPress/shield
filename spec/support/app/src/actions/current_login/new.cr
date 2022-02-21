class CurrentLogin::New < BrowserAction
  include Shield::CurrentLogin::New

  get "/log-in" do
    operation = StartCurrentLogin.new(remote_ip: remote_ip?, session: session)
    html NewPage, operation: operation
  end
end
