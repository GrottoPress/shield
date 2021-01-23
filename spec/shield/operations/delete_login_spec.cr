require "../../spec_helper"

describe Shield::DeleteLogin do
  it "deletes login" do
    email = "user@domain.com"
    password = "password12U~password"

    user = UserBox.create &.email(email).password(password)
    UserOptionsBox.create &.user_id(user.id)
    login = LoginBox.create &.user_id(user.id)

    DeleteLogin.run(record: login) do |operation, deleted_login|
      operation.deleted?.should be_true

      LoginQuery.new.id(login.id).first?.should be_nil
    end
  end
end
