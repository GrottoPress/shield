require "../../../spec_helper"

describe Shield::EmailConfirmations::Show do
  it "shows email confirmation" do
    password = "password4APASSWORD<"

    user = UserFactory.create &.password(password)
    email_confirmation = EmailConfirmationFactory.create &.user_id(user.id)
    UserOptionsFactory.create &.user_id(user.id)

    client = ApiClient.new
    client.browser_auth(user, password)

    response = client.exec(EmailConfirmations::Show.with(
      email_confirmation_id: email_confirmation.id
    ))

    response.body.should eq("EmailConfirmations::ShowPage")
  end

  it "requires logged in" do
    response = ApiClient.exec(EmailConfirmations::Show.with(
      email_confirmation_id: 5
    ))

    response.status.should eq(HTTP::Status::FOUND)
    response.headers["X-Logged-In"]?.should eq("false")
  end
end
