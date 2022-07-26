Shield.configure do |settings|
  settings.bearer_login_allowed_scopes = BearerScope.action_scopes.map(&.to_s)
end
