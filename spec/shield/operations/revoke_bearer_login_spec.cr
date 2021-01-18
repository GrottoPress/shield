require "../../spec_helper"

describe Shield::RevokeBearerLogin do
  it "ends bearer login" do
    bearer_login = BearerLoginBox.create &.user_id(UserBox.create.id)

    bearer_login.active?.should be_true

    RevokeBearerLogin.update(bearer_login) do |operation, updated_bearer_login|
      operation.saved?.should be_true

      updated_bearer_login.active?.should be_false
    end
  end
end
