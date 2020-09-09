require "../../spec_helper"

describe Shield::AuthorizationPipes do
  describe "#check_authorization" do
    it "denies authorization" do
      password = "password_1Apassword"

      user = create_current_user!(
        password: password,
        password_confirmation: password
      )

      client = ApiClient.new

      response = client.exec(Logins::Create, login: {
        email: user.email,
        password: password
      })

      body(response)["session"]?.should_not be_nil

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      body(response)["authorized"]?.should be_false
    end

    it "grants authorization" do
      password = "password_1Apassword"

      user = create_user!(
        password: password,
        password_confirmation: password,
        level: User::Level.new(:admin)
      )

      client = ApiClient.new

      response = client.exec(Logins::Create, login: {
        email: user.email,
        password: password
      })

      body(response)["session"]?.should_not be_nil

      client.headers("Cookie": response.headers["Set-Cookie"])
      response = client.exec(Users::Show.with(user_id: user.id))

      body(response)["authorized"]?.should be_nil
    end
  end
end
