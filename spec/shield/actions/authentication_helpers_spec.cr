require "../../spec_helper"

describe Shield::AuthenticationHelpers do
  describe "#current_user" do
    it "works" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      email_2 = "user@domain.tld"
      password_2 = "assword4A,PASSWOR"

      user = create_current_user!(
        email: email,
        password: password,
        password_confirmation: password
      )

      user_2 = create_current_user!(
        email: email_2,
        password: password_2,
        password_confirmation: password_2
      )

      client = ApiClient.new

      response = client.exec(Logins::Create, login: {
        email: email,
        password: password
      })

      response_2 = client.exec(Logins::Create, login: {
        email: email_2,
        password: password_2
      })

      body(response)["current_user"]?.should eq(user.id)
      body(response_2)["current_user"]?.should eq(user_2.id)
    end
  end
end
