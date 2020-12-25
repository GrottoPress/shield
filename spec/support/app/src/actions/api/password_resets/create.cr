class Api::PasswordResets::Create < ApiAction
  include Shield::Api::PasswordResets::Create

  post "/password-resets" do
    run_operation
  end
end
