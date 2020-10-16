require "../../../spec_helper"

describe Shield::EmailConfirmations::Show do
  it "works" do
    StartEmailConfirmation.submit(
      params(user_id: 1_i64, email: "email@domain.tld"),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    ) do |operation, email_confirmation|
      email_confirmation = email_confirmation.not_nil!

      response = ApiClient.get(EmailConfirmation.url(operation))

      response.status.should eq(HTTP::Status::FOUND)

      cookies = Lucky::CookieJar.from_request_cookies(response.cookies)
      session = Lucky::Session.from_cookie_jar(cookies)

      from_session = EmailConfirmationSession.new(session)

      from_session
        .email_confirmation_user_id
        .should(eq email_confirmation.user_id)

      from_session.email_confirmation_email.should eq(email_confirmation.email)

      from_session
        .email_confirmation_ip_address
        .should(eq email_confirmation.ip_address)
    end
  end
end
