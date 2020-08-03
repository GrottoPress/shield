require "../../../spec_helper"

describe Shield::ValidatePassword do
  it "rejects short passwords" do
    password = "pAssword1!"

    create_current_user(
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      operation
        .password
        .errors
        .find(&.includes? "too short")
        .should_not(be_nil)
    end
  end

  it "rejects mismatched passwords" do
    create_current_user(
      password: "password1APASSWORD?",
      password_confirmation: "PASSWORD1Apassword?"
    ) do |operation, user|
      user.should be_nil

      operation
        .password_confirmation
        .errors
        .find(&.includes? "must match")
        .should_not(be_nil)
    end
  end

  it "enforces number in password" do
    password = "passwordAPASSWORD-"

    create_current_user(
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      operation
        .password
        .errors
        .find(&.includes? " number")
        .should_not(be_nil)
    end
  end

  it "does not enforce number in password" do
    Shield.temp_config(password_require_number: false) do
      password = "passwordAPASSWORD-"

      create_current_user(
        password: password,
        password_confirmation: password
      ) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces lowercase letter in password" do
    password = "PASSWORD1AP%ASSWORD"

    create_current_user(
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      operation
        .password
        .errors
        .find(&.includes? "lowercase letter")
        .should_not(be_nil)
    end
  end

  it "does not enforce lowercase letter in password" do
    Shield.temp_config(password_require_lowercase: false) do
      password = "PASSWORD1AP%ASSWORD"

      create_current_user(
        password: password,
        password_confirmation: password
      ) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces uppercase letter in password" do
    password = "pa(ssword1apassword"

    create_current_user(
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      operation
        .password
        .errors
        .find(&.includes? "uppercase letter")
        .should_not(be_nil)
    end
  end

  it "does not enforce uppercase letter in password" do
    Shield.temp_config(password_require_uppercase: false) do
      password = "pa(ssword1apassword"

      create_current_user(
        password: password,
        password_confirmation: password
      ) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces special character in password" do
    password = "password1Apassword"

    create_current_user(
      password: password,
      password_confirmation: password
    ) do |operation, user|
      user.should be_nil

      operation
        .password
        .errors
        .find(&.includes? "special character")
        .should_not(be_nil)
    end
  end

  it "does not enforce special character in password" do
    Shield.temp_config(password_require_special_char: false) do
      password = "password1Apassword"

      create_current_user(
        password: password,
        password_confirmation: password
      ) do |operation, user|
        user.should be_a(User)
      end
    end
  end
end
