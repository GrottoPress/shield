unless Bool.adapter.parse(ENV["SKIP_CREATE_DB"]?.to_s).value
  Db::Create.new(quiet: true).call
end

Db::Migrate.new(quiet: true).call

Spec.before_suite do
  BaseModel.database.truncate(restart_identity: false)
end

Avram::SpecHelper.use_transactional_specs(Avram.settings.database_to_migrate)
