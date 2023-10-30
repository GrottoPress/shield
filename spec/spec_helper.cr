ENV["LUCKY_ENV"] = "test"

require "spec"
require "webmock"

require "./support/boot"
require "./setup/**"

require "../src/spec"
require "lucille/cockroach"

include Carbon::Expectations
include Lucky::RequestExpectations

Avram::SpecHelper.use_transactional_specs(AppDatabase)

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!
