Shield.configure do |settings|
  settings.bcrypt_cost = Lucky::Env.production? ? 12 : 4
end
