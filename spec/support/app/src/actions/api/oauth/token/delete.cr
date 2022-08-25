class Api::Oauth::Token::Delete < ApiAction
  include Shield::Api::Oauth::Token::Delete

  post "/oauth/token/delete" do
    run_operation
  end
end
