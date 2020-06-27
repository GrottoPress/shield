Lucky::Server.configure do |settings|
    settings.secret_key_base = ENV["SECRET_KEY_BASE"]
    settings.host = ENV["SERVER_HOST"]
    settings.port = ENV["SERVER_PORT"].to_i
    settings.gzip_enabled = false
end

Lucky::ForceSSLHandler.configure do |settings|
  settings.enabled = false
end
