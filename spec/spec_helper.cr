ENV["LUCKY_ENV"] = "test"

require "spec"

require "./app/src/app"
require "./support/**"
require "./setup/**"

include Carbon::Expectations
include Lucky::RequestExpectations

def body(response)
  JSON.parse(response.body)
end

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!
