require "../../../spec_helper"

describe Shield::EmailConfirmations::Update do
  it "works" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = UserBox.create &.email(email)
      .password_digest(CryptoHelper.hash_bcrypt(password))

    StartEmailConfirmation.create(
      params(email: new_email),
      user_id: user.id,
      remote_ip: ip_address
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!

      session = Lucky::Session.new
      cookies = Lucky::CookieJar.empty_jar

      LogUserIn.create!(
        params(email: email, password: password),
        session: session,
        remote_ip: ip_address
      )

      EmailConfirmationSession.new(session).set(email_confirmation, operation)

      cookies.set(Lucky::Session.settings.key, session.to_json)
      headers = cookies.updated.add_response_headers(HTTP::Headers.new)

      client = ApiClient.new

      client.headers("Cookie": headers["Set-Cookie"])
      response = client.exec(EmailConfirmations::Update)

      response.should send_json(200, exit: 0)
    end

    user.reload.email.should eq(new_email)
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmations::Update)

    response.should send_json(403, logged_in: false)
  end
end
