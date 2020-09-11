ENV["LUCKY_ENV"] = "test"

require "spec"

require "./app/src/app"
require "./support/**"
require "./setup/**"

include Carbon::Expectations
include Lucky::RequestExpectations

def assert_valid(attribute)
  attribute.errors.should be_empty
end

def assert_valid(attribute, text)
  attribute.errors.select(&.includes? text).should be_empty
end

def assert_invalid(attribute)
  attribute.errors.should_not be_empty
end

def assert_invalid(attribute, text)
  attribute.errors.select(&.includes? text).size.should eq(1)
end

def params(**named_args)
  Avram::Params.new named_args.to_h
    .transform_keys(&.to_s)
    .transform_values &.to_s
end

def body(response)
  JSON.parse(response.body)
end

# For debugging :-)
#
#  ```crystal
#  body(response) do |body, error|
#    puts body if body
#    puts error if error
#  end
#  ```
def body(response)
  yield JSON.parse(response.body), nil
rescue e
  yield(nil, {error: e.message, body: response.body}.to_json)
end

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!
