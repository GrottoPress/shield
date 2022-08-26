class Api::Oauth::Token::Create < ApiAction
  include Shield::Api::Oauth::Token::Create

  post "/oauth/token" do
    run_operation
  end
end
