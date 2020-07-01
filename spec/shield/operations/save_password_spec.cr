require "../../spec_helper"

describe Shield::SavePassword do
  it "requires password" do
    create_current_user(
      password: "",
      password_confirmation: ""
    ) do |operation, user|
      user.should be_nil

      operation
        .password_hash
        .errors
        .find(&.includes? " required")
        .should_not(be_nil)
    end
  end

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

  it "does not update password if new password empty" do
    user = create_current_user!

    SaveCurrentUser.update(
      user,
      password: "",
      password_confirmation: ""
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.password_hash.should eq(user.password_hash)
    end
  end

  it "sends password change notification" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apasswor"

    user = create_current_user!(
      password: password,
      password_confirmation: password,
      password_notify: "1"
    )

    SaveCurrentUser.update(
      user,
      password: new_password,
      password_confirmation: new_password
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should(be_delivered)
    end
  end

  it "does not send password change notification" do
    password = "pass)word1Apassword"
    new_password = "ass)word1Apassword"

    user = create_current_user!(
      password: password,
      password_confirmation: password,
      password_notify: "0"
    )

    SaveCurrentUser.update(
      user,
      password: new_password,
      password_confirmation: new_password
    ) do |operation, updated_user|
      operation.saved?.should be_true
      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should_not(be_delivered)
    end
  end

  it "does not send password change notification if password did not change" do
    password = "pass)word1Apassword"

    user = create_current_user!(
      password: password,
      password_confirmation: password,
      password_notify: "1"
    )

    SaveCurrentUser.update(
      user,
      email: "user2@example.tld",
      password: password,
      password_confirmation: password
    ) do |operation, updated_user|
      operation.saved?.should be_true

      PasswordChangeNotificationEmail
        .new(operation, updated_user)
        .should_not(be_delivered)
    end
  end

  it "does not send password change notification for a newly created user" do
    password = "password1=Apassword"

    create_current_user(password_notify: "1") do |operation, user|
      PasswordChangeNotificationEmail
        .new(operation, user.not_nil!)
        .should_not(be_delivered)
    end
  end
end
