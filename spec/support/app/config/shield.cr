Shield.configure do |settings|
  settings.bearer_login_allowed_scopes = BearerScope.action_scopes.map(&.to_s)
  settings.oauth_client_name_filter = /^grotto.*$/i
  settings.oauth_code_challenge_methods_allowed = ["plain", "S256"]
end
