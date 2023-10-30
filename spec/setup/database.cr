unless Bool.adapter.parse(ENV["SKIP_CREATE_DB"]?.to_s).value
  Db::Create.new(quiet: true).call
end

Db::Migrate.new(quiet: true).call

Avram::SpecHelper.use_transactional_specs(Avram.settings.database_to_migrate)
