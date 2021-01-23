require "../../spec_helper"

describe Shield::DeleteBearerLogin do
  it "deletes bearer login" do
    bearer_login = BearerLoginBox.create &.user_id(UserBox.create.id)

    DeleteBearerLogin.run(
      record: bearer_login
    ) do |operation, deleted_bearer_login|
      operation.deleted?.should be_true

      BearerLoginQuery.new.id(bearer_login.id).first?.should be_nil
    end
  end
end
