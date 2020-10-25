require "../../../spec_helper"

describe Shield::BearerLoginVerifier do
  describe "#verify" do
    it "verifies bearer login" do
      CreateBearerLogin.create(
        params(name: "some token"),
        user_id: UserBox.create.id,
        scopes: ["posts.new", "posts.create"],
        all_scopes: ["posts.new", "posts.create"]
      ) do |operation, bearer_login|
        bearer_login = bearer_login.not_nil!

        headers = HTTP::Headers{
          "Authorization" => BearerLoginHelper.bearer_header(
            bearer_login,
            operation
          )
        }

        headers_2 = HTTP::Headers{
          "Authorization" => BearerLoginHelper.bearer_header(
            1,
            "abcdefghijklmnopqrstuvwxyz"
          )
        }

        BearerLoginHeaders.new(headers).verify.should be_a(BearerLogin)
        BearerLoginHeaders.new(headers_2).verify.should be_nil
      end
    end
  end
end
