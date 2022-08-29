struct Oauth::Authorization::NewPage < MainLayout
  needs operation : StartOauthGrant

  def content
    text "Oauth::Authorization::NewPage"
  end
end
