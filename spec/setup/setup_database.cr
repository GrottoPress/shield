unless Bool::Lucky.parse(ENV["SKIP_CREATE_DB"]?.to_s).value
  Db::Create.new(quiet: true).call
end

Db::Migrate.new(quiet: true).call
