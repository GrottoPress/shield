require "../../spec_helper"

describe Shield::AuthorizationPipes do
  describe "#require_authorization" do
    pending "enforces authorization" do
      user = create_current_user!

      client = AppClient.new

      response = client.exec(Logins::Create, login: params)
      body(response)["session"]?.should_not be_nil

      client.headers("Cookie": response.headers["Set-Cookie"])

      expect_raises(Shield::NoAuthorizationError) do
        response = client.exec(Users::Show.with(user_id: user.id))
      end
    end
  end
end
