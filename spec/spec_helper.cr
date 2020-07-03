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

def create_user(
  *,
  email = "user@domain.tld",
  password = "password12U~password",
  password_confirmation = "password12U~password",
  level = User::Level.new(:author),
  login_notify = true,
  password_notify = true
)
  params = Avram::Params.new({
    "email" => email,
    "password" => password,
    "password_confirmation" => password_confirmation,
    "level" => level.value.to_s,
    "login_notify" => login_notify.to_s,
    "password_notify" => password_notify.to_s,
  })

  SaveUser.create(params) do |operation, user|
    yield operation, user
  end
end

def create_user!(
  *,
  email = "user@domain.tld",
  password = "password12U~password",
  password_confirmation = "password12U~password",
  level = User::Level.new(:author),
  login_notify = true,
  password_notify = true
)
  params = Avram::Params.new({
    "email" => email,
    "password" => password,
    "password_confirmation" => password_confirmation,
    "level" => level.value.to_s,
    "login_notify" => login_notify.to_s,
    "password_notify" => password_notify.to_s,
  })

  SaveUser.create!(params)
end

def create_current_user(
  *,
  email = "user@domain.tld",
  password = "password12U~password",
  password_confirmation = "password12U~password",
  login_notify = true,
  password_notify = true
)
  params = Avram::Params.new({
    "email" => email,
    "password" => password,
    "password_confirmation" => password_confirmation,
    "login_notify" => login_notify.to_s,
    "password_notify" => password_notify.to_s,
  })

  SaveCurrentUser.create(params) do |operation, user|
    yield operation, user
  end
end

def create_current_user!(
  *,
  email = "user@domain.tld",
  password = "password12U~password",
  password_confirmation = "password12U~password",
  login_notify = true,
  password_notify = true
)
  params = Avram::Params.new({
    "email" => email,
    "password" => password,
    "password_confirmation" => password_confirmation,
    "login_notify" => login_notify.to_s,
    "password_notify" => password_notify.to_s,
  })

  SaveCurrentUser.create!(params)
end

Avram::Migrator::Runner.new.ensure_migrated!
Avram::SchemaEnforcer.ensure_correct_column_mappings!
Habitat.raise_if_missing_settings!
