require "../../../spec_helper"

private class SaveUser < User::SaveOperation
  permit_columns :email, :level
  attribute password : String

  before_save do
    set_password_digest
  end

  include Shield::ValidatePassword

  private def set_password_digest
    password_digest.value = password.value
  end
end

describe Shield::ValidatePassword do
  it "rejects short passwords" do
    SaveUser.create(params(
      email: "user@example.tld",
      level: "Author",
      password: "pAssword1!"
    )) do |operation, user|
      user.should be_nil

      operation.password
        .should have_error("operation.error.password_length_invalid")
    end
  end

  it "enforces number in password" do
    SaveUser.create(params(
      email: "user@example.tld",
      level: "Author",
      password: "passwordAPASSWORD-"
    )) do |operation, user|
      user.should be_nil

      operation.password
        .should have_error("operation.error.password_number_required")
    end
  end

  it "does not enforce number in password if setting is false" do
    Shield.temp_config(password_require_number: false) do
      SaveUser.create(params(
        email: "user@example.tld",
        level: "Author",
        password: "passwordAPASSWORD-"
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces lowercase letter in password" do
    SaveUser.create(params(
      email: "user@example.tld",
      level: "Author",
      password: "PASSWORD1AP%ASSWORD"
    )) do |operation, user|
      user.should be_nil

      operation.password
        .should have_error("operation.error.password_lowercase_required")
    end
  end

  it "does not enforce lowercase letter in password if setting is false" do
    Shield.temp_config(password_require_lowercase: false) do
      SaveUser.create(params(
        email: "user@example.tld",
        level: "Author",
        password: "PASSWORD1AP%ASSWORD"
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces uppercase letter in password" do
    SaveUser.create(params(
      email: "user@example.tld",
      level: "Author",
      password: "pa(ssword1apassword"
    )) do |operation, user|
      user.should be_nil

      operation.password
        .should have_error("operation.error.password_uppercase_required")
    end
  end

  it "does not enforce uppercase letter in password if setting is false" do
    Shield.temp_config(password_require_uppercase: false) do
      SaveUser.create(params(
        email: "user@example.tld",
        level: "Author",
        password: "pa(ssword1apassword"
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces special character in password" do
    SaveUser.create(params(
      email: "user@example.tld",
      level: "Author",
      password: "password1Apassword"
    )) do |operation, user|
      user.should be_nil

      operation.password
        .should have_error("operation.error.password_special_char_required")
    end
  end

  it "does not enforce special character in password if setting is false" do
    Shield.temp_config(password_require_special_char: false) do
      SaveUser.create(params(
        email: "user@example.tld",
        level: "Author",
        password: "password1Apassword"
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end
end
