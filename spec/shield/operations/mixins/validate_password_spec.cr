require "../../../spec_helper"

describe Shield::ValidatePassword do
  it "rejects short passwords" do
    password = "pAssword1!"

    RegisterCurrentUser.create(params(
      password: password,
      password_confirmation: password
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "too short")
    end
  end

  it "rejects mismatched passwords" do
    RegisterCurrentUser.create(params(
      password: "password1APASSWORD?",
      password_confirmation: "PASSWORD1Apassword?"
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password_confirmation, "must match")
    end
  end

  it "enforces number in password" do
    password = "passwordAPASSWORD-"

    RegisterCurrentUser.create(params(
      password: password,
      password_confirmation: password
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, " number")
    end
  end

  it "does not enforce number in password" do
    Shield.temp_config(password_require_number: false) do
      password = "passwordAPASSWORD-"

      RegisterCurrentUser.create(params(
        email: "user@example.net",
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: true,
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces lowercase letter in password" do
    password = "PASSWORD1AP%ASSWORD"

    RegisterCurrentUser.create(params(
      password: password,
      password_confirmation: password
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "lowercase letter")
    end
  end

  it "does not enforce lowercase letter in password" do
    Shield.temp_config(password_require_lowercase: false) do
      password = "PASSWORD1AP%ASSWORD"

      RegisterCurrentUser.create(params(
        email: "user@example.org",
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: true
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces uppercase letter in password" do
    password = "pa(ssword1apassword"

    RegisterCurrentUser.create(params(
      password: password,
      password_confirmation: password
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "uppercase letter")
    end
  end

  it "does not enforce uppercase letter in password" do
    Shield.temp_config(password_require_uppercase: false) do
      password = "pa(ssword1apassword"

      RegisterCurrentUser.create(params(
        email: "user@domain.com",
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: true
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces special character in password" do
    password = "password1Apassword"

    RegisterCurrentUser.create(params(
      password: password,
      password_confirmation: password
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "special character")
    end
  end

  it "does not enforce special character in password" do
    Shield.temp_config(password_require_special_char: false) do
      password = "password1Apassword"

      RegisterCurrentUser.create(params(
        email: "user@domain.net",
        password: password,
        password_confirmation: password,
        login_notify: true,
        password_notify: true
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end
end
