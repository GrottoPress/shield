AppDatabase.configure do |settings|
  settings.credentials = Avram::Credentials.parse(ENV["DATABASE_URL"])
end

Avram.configure do |settings|
  settings.database_to_migrate = AppDatabase
  settings.lazy_load_enabled = Lucky::Env.production?
end
