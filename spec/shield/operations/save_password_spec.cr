require "../../spec_helper"

describe Shield::SavePassword do
  it "rejects short passwords" do
    password = "pAssword1!"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
      user.should be_nil

      operation
        .password
        .errors
        .find(&.includes? "too short")
        .should_not(be_nil)
    end
  end

  it "rejects mismatched passwords" do
    params = {
      email: "user@example.tld",
      password: "password1APASSWORD?",
      password_confirmation: "PASSWORD1Apassword?"
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

      params = {
        email: "user@example.tld",
        password: password,
        password_confirmation: password
      }

      SaveCurrentUser.create(**params) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces lowercase letter in password" do
    password = "PASSWORD1AP%ASSWORD"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

      params = {
        email: "user@example.tld",
        password: password,
        password_confirmation: password
      }

      SaveCurrentUser.create(**params) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces uppercase letter in password" do
    password = "pa(ssword1apassword"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

      params = {
        email: "user@example.tld",
        password: password,
        password_confirmation: password
      }

      SaveCurrentUser.create(**params) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "enforces special character in password" do
    password = "password1Apassword"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
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

      params = {
        email: "user@example.tld",
        password: password,
        password_confirmation: password
      }

      SaveCurrentUser.create(**params) do |operation, user|
        user.should be_a(User)
      end
    end
  end

  it "sends password change notification" do
    Shield.temp_config(password_notify_change: true) do
      password = "pass)word1Apassword"

      params = {
        email: "user@example.tld",
        password: password,
        password_confirmation: password
      }

      SaveCurrentUser.create(**params) do |operation, user|
        user.should be_a(User)

        password = "ass)word1Apassword"

        SaveCurrentUser.update(
          user.not_nil!,
          password: password,
          password_confirmation: password
        ) do |operation, updated_user|
          operation.saved?.should be_true
          PasswordChangeNotificationEmail.new(updated_user).should be_delivered
        end
      end
    end
  end

  it "does not send password change notification" do
    password = "pass)word1Apassword"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
      user.should be_a(User)

      password = "ass)word1Apassword"

      SaveCurrentUser.update(
        user.not_nil!,
        password: password,
        password_confirmation: password
      ) do |operation, updated_user|
        operation.saved?.should be_true

        PasswordChangeNotificationEmail
          .new(updated_user)
          .should_not(be_delivered)
      end
    end
  end

  it "does not send password change notification for a newly created user" do
    password = "password1=Apassword"

    params = {
      email: "user@example.tld",
      password: password,
      password_confirmation: password
    }

    SaveCurrentUser.create(**params) do |operation, user|
      user.should be_a(User)

      PasswordChangeNotificationEmail
        .new(user.not_nil!)
        .should_not(be_delivered)
    end
  end
end
