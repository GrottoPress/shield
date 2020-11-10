require "../../../spec_helper"

describe Shield::ValidatePassword do
  it "rejects short passwords" do
    RegisterCurrentUser.create(
      params(password: "pAssword1!")
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "too short")
    end
  end

  it "enforces number in password" do
    RegisterCurrentUser.create(
      params(password: "passwordAPASSWORD-")
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, " number")
    end
  end

  it "does not enforce number in password" do
    Shield.temp_config(password_require_number: false) do
      RegisterCurrentUser.create(params(
        email: "user@example.net",
        password: "passwordAPASSWORD-",
        login_notify: true,
        password_notify: true,
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces lowercase letter in password" do
    RegisterCurrentUser.create(params(
      password: "PASSWORD1AP%ASSWORD"
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "lowercase letter")
    end
  end

  it "does not enforce lowercase letter in password" do
    Shield.temp_config(password_require_lowercase: false) do
      RegisterCurrentUser.create(params(
        email: "user@example.org",
        password: "PASSWORD1AP%ASSWORD",
        login_notify: true,
        password_notify: true
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces uppercase letter in password" do
    RegisterCurrentUser.create(
      params(password: "pa(ssword1apassword")
    ) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "uppercase letter")
    end
  end

  it "does not enforce uppercase letter in password" do
    Shield.temp_config(password_require_uppercase: false) do
      RegisterCurrentUser.create(params(
        email: "user@domain.com",
        password: "pa(ssword1apassword",
        login_notify: true,
        password_notify: true
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces special character in password" do
    RegisterCurrentUser.create(params(
      password: "password1Apassword"
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, "special character")
    end
  end

  it "does not enforce special character in password" do
    Shield.temp_config(password_require_special_char: false) do
      RegisterCurrentUser.create(params(
        email: "user@domain.net",
        password: "password1Apassword",
        login_notify: true,
        password_notify: true
      )) do |operation, user|
        user.should be_a(User)
      end
    end
  end
end
