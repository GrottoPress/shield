require "../../spec_helper"

describe Shield::AuthenticationPipes do
  describe "#require_logged_in" do
    it "requires logged in" do
      response = body(AppClient.exec(Logins::Destroy))

      response["logged_in"]?.should be_false
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
end
