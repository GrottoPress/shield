require "../../spec_helper"

describe Shield::DeleteLogin do
  it "deletes login" do
    email = "user@domain.com"
    password = "password12U~password"

    user = UserBox.create &.email(email).password_digest(
      BcryptHash.new(password).hash
    )

    login = LogUserIn.create!(
      params(email: email, password: password),
      remote_ip: Socket::IPAddress.new("0.0.0.0", 0)
    )

    DeleteLogin.run(params(id: login.id)) do |operation, deleted_login|
      deleted_login.should be_a(Login)

      LoginQuery.new.id(login.id).first?.should be_nil
    end
  end

  it "requires login id" do
    DeleteLogin.run(params(some_id: 3)) do |operation, deleted_login|
      deleted_login.should be_nil

      assert_invalid(operation.id, " required")
    end
  end

  it "requires login exists" do
    DeleteLogin.run(id: 1_i64) do |operation, deleted_login|
      deleted_login.should be_nil

      assert_invalid(operation.id, "not exist")
    end
  end
end
