require "../../spec_helper"

describe Shield::LoginHelpers do
  describe "#current_user" do
    it "works" do
      email = "user@example.tld"
      password = "password4APASSWORD<"

      email_2 = "user@domain.tld"
      password_2 = "assword4A,PASSWOR"

      user = UserBox.create &.email(email)
        .password_digest(BcryptHash.new(password).hash)

      user_2 = UserBox.create &.email(email_2)
        .password_digest(BcryptHash.new(password_2).hash)

      client = ApiClient.new

      response = client.exec(CurrentLogin::Create, login: {
        email: email,
        password: password
      })

      response_2 = client.exec(CurrentLogin::Create, login: {
        email: email_2,
        password: password_2
      })

      response.headers["X-User-ID"] = user.id.to_s
      response_2.headers["X-User-ID"] = user_2.id.to_s
    end
  end
end
