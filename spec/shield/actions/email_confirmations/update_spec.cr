require "../../../spec_helper"

describe Shield::EmailConfirmations::Update do
  it "works" do
    email = "user@example.tld"
    new_email = "user@domain.net"
    password = "password4APASSWORD<"
    ip_address = Socket::IPAddress.new("128.0.0.2", 5000)

    user = create_current_user!(
      email: email,
      password: password,
      password_confirmation: password
    )

    StartEmailConfirmation.submit(
      params(user_id: user.id, email: new_email),
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

      EmailConfirmationSession.new(session).set(email_confirmation)

      cookies.set(Lucky::Session.settings.key, session.to_json)
      headers = cookies.updated.add_response_headers(HTTP::Headers.new)

      client = ApiClient.new

      client.headers("Cookie": headers["Set-Cookie"])
      response = client.exec(EmailConfirmations::Update)

      body(response)["status"]?.should eq(0)
    end

    user.reload.email.should eq(new_email)
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmations::Update)

    body(response)["logged_in"]?.should be_false
  end
end
