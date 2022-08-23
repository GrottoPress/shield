class Api::Oauth::Token::Verify < ApiAction
  include Shield::Api::Oauth::Token::Verify

  post "/oauth/token/verify" do
    run_operation
  end
end
