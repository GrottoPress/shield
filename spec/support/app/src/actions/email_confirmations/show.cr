class EmailConfirmations::Show < ApiAction
  include Shield::EmailConfirmations::Show

  param token : String

  get "/email-confirmations" do
    run_operation
  end
end
