class Api::Oauth::Token::Destroy < ApiAction
  include Shield::Api::Oauth::Token::Destroy

  post "/oauth/token/revoke" do
    run_operation
  end
end
