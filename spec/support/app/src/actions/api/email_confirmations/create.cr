class Api::EmailConfirmations::Create < ApiAction
  include Shield::Api::EmailConfirmations::Create

  post "/email-confirmations" do
    run_operation
  end
end
