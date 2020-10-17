class PasswordResets::New < BrowserAction
  include Shield::PasswordResets::New

  get "/password-resets/new" do
    json({exit: 1})
  end
end
