require "../../../spec_helper"

private class CreateUser < User::SaveOperation
  permit_columns :email, :level
  attribute password : String

  include Shield::CreatePassword
end

describe Shield::CreatePassword do
  it "saves password" do
    password = "password12U-password"

    CreateUser.create(params(
      email: "user@example.tld",
      level: "Author",
      password: password
    )) do |_, user|
      user.should be_a(User)

      user.try do |user|
        BcryptHash.new(password)
          .verify?(user.password_digest)
          .should(be_true)
      end
    end
  end

  it "requires password" do
    CreateUser.create(params(
      email: "user@domain.tld",
      level: "Author"
    )) do |operation, user|
      user.should be_nil

      assert_invalid(operation.password, " required")
      assert_valid(operation.password_digest, " required")
    end
  end
end
