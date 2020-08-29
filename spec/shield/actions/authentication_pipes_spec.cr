require "../../spec_helper"

describe Shield::AuthenticationPipes do
  describe "#require_logged_in" do
    it "requires logged in" do
      response = body(AppClient.exec(Logins::Destroy))

      response["logged_in"]?.should be_false
      response["return_url"]?.should eq(Logins::Destroy.path)
    end
  end

  describe "#require_logged_out" do
    it "requires logged out" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      client = AppClient.new

      response = client.exec(Logins::Create, login: {
        email: email,
        password: password
      })

      body(response)["session"]?.should_not be_nil

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Logins::Create)

      body(response)["logged_in"]?.should be_true
    end
  end

  describe "#pin_login_to_ip_address" do
    it "accepts login from same IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      client = AppClient.new

      response = client.exec(Logins::Create, login: {
        email: email,
        password: password
      })

      body(response)["session"]?.should_not be_nil

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      body(response)["ip_address_changed"]?.should be_nil
    end

    it "rejects login from different IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      user = create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      client = AppClient.new

      response = client.exec(Logins::Create, login: {
        email: email,
        password: password
      })

      body(response)["session"]?.should_not be_nil

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Edit.with(user_id: user.id))

      body(response)["ip_address_changed"]?.should be_true
    end
  end

  describe "#pin_password_reset_to_ip_address" do
    it "accepts password reset from same IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        client = AppClient.new

        response = client.get(PasswordResetHelper.password_reset_url(
          password_reset,
          operation
        ))

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(PasswordResets::Edit)

        body(response)["ip_address_changed"]?.should be_nil
      end
    end

    it "rejects password reset from different IP" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      StartPasswordReset.create(
        params(email: email),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, password_reset|
        password_reset = password_reset.not_nil!

        client = AppClient.new

        response = client.get(PasswordResetHelper.password_reset_url(
          password_reset,
          operation
        ))

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(PasswordResets::Update)

        body(response)["ip_address_changed"]?.should be_true
      end
    end
  end

  describe "#pin_email_confirmation_to_ip_address" do
    it "accepts email confirmation from same IP" do
      StartEmailConfirmation.submit(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("128.0.0.2", 5000)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        client = AppClient.new

        response = client.get(email_confirmation.url(operation))

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(CurrentUser::New)

        body(response)["ip_address_changed"]?.should be_nil
      end
    end

    it "rejects email confirmation from different IP" do
      StartEmailConfirmation.submit(
        params(email: "user@example.tld"),
        remote_ip: Socket::IPAddress.new("129.0.0.3", 9000)
      ) do |operation, email_confirmation|
        email_confirmation = email_confirmation.not_nil!

        client = AppClient.new

        response = client.get(email_confirmation.url(operation))

        client.headers("Cookie": response.headers["Set-Cookie"])
        response = client.exec(CurrentUser::New)

        body(response)["ip_address_changed"]?.should be_true
      end
    end
  end
end
