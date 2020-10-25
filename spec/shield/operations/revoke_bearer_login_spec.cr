require "../../spec_helper"

describe Shield::RevokeBearerLogin do
  it "ends bearer login" do
    session = Lucky::Session.new

    bearer_login = CreateBearerLogin.create!(
      params(name: "some token"),
      user_id: UserBox.create.id,
      scopes: ["posts.index"],
      all_scopes: ["posts.index", "posts.create"]
    )

    bearer_login.active?.should be_true

    RevokeBearerLogin.update(bearer_login) do |operation, updated_bearer_login|
      operation.saved?.should be_true

      updated_bearer_login.active?.should be_false
    end
  end
end
