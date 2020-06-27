unless ENV["SKIP_CREATE_DB"]?.in?({"1", "true", "yes"})
  Db::Create.new(quiet: true).call
end

Db::Migrate.new(quiet: true).call
