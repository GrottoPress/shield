require "../../spec_helper"

describe Shield::BearerLoginHeaders do
  it "deactivates login when expired but active" do
    Shield.temp_config(bearer_login_expiry: 2.seconds) do
      CreateBearerLogin.create(
        params(name: "some token"),
        user_id: UserBox.create.id,
        scopes: ["posts.new", "posts.create"],
        all_scopes: ["posts.new", "posts.create"]
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        headers = HTTP::Headers{
          "Authorization" => BearerLoginHelper.authorization_header(
            bearer_login,
            operation
          )
        }

        sleep 3

        bearer_login.status.started?.should be_true
        BearerLoginHeaders.new(headers).verify.should be_nil
        bearer_login.reload.status.expired?.should be_true
      end
    end
  end
end
