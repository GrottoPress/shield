class Api::PasswordResets::Show < ApiAction
  include Shield::Api::PasswordResets::Show

  get "/password-resets/:token" do
    json ItemResponse.new(password_reset: password_reset)
  end
end
