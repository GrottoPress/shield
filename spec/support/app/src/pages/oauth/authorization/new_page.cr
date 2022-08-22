struct Oauth::Authorization::NewPage < MainLayout
  needs operation : StartOauthAuthorization

  def content
    text "Oauth::Authorization::NewPage"
  end
end
