require "./server"

Lucky::Session.configure do |settings|
  settings.key = "_shield_spec_session"
end

Lucky::CookieJar.configure do |settings|
  settings.on_set = ->(cookie : HTTP::Cookie) do
    cookie.secure(Lucky::ForceSSLHandler.settings.enabled)
    cookie.http_only(true)
    cookie.path("/")
  end
end
