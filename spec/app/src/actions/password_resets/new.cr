class PasswordResets::New < ApiAction
  include Shield::PasswordResets::New

  get "/password-resets/new" do
    json({status: 1})
  end
end
