require "../../../spec_helper"

describe Shield::EmailConfirmations::Delete do
  it "deletes email confirmation" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    UserOptionsFactory.create &.user_id(user.id)
    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(EmailConfirmations::Delete.with(
      email_confirmation_id: email_confirmation.id
    ))

    response.headers["X-Email-Confirmation-ID"]?
      .should(eq email_confirmation.id.to_s)
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmations::Delete.with(
      email_confirmation_id: 9
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
