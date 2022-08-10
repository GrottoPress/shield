struct OauthClients::Secret::ShowPage < MainLayout
  needs oauth_client : OauthClient?
  needs secret : String?

  def content
    text secret.to_s if secret
    text ":" if secret && oauth_client
    text oauth_client.try(&.id).to_s if oauth_client
  end
end
