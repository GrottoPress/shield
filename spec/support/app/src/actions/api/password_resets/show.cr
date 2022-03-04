class Api::PasswordResets::Show < ApiAction
  include Shield::Api::PasswordResets::Show

  get "/password-resets/:token" do
    json({
      status: "success",
      data: {password_reset: PasswordResetSerializer.new(password_reset)}
    })
  end
end
