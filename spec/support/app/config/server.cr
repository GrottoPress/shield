Lucky::Server.configure do |settings|
  settings.secret_key_base = "abcdefghijklmnopqrstuvwxyz123456"
  settings.host = "0.0.0.0"
  settings.port = 5000
  settings.gzip_enabled = false
end

Lucky::ForceSSLHandler.configure do |settings|
  settings.enabled = false
end
