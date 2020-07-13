require "../../spec_helper"

describe Shield::Authorization do
  it "allows user to perform action" do
    user = User.new(
      id: 1_i64,
      created_at: Time.utc,
      email: "user@example.tld",
      level: User::Level.new(:admin).to_i,
      password_hash: Login.hash_bcrypt("password_1Apassword"),
      updated_at: Time.utc
    )

    user_2 = User.new(
      id: 2_i64,
      created_at: Time.utc,
      email: "user_2@example.tld",
      level: User::Level.new(:editor).to_i,
      password_hash: Login.hash_bcrypt("password_1Apassword"),
      updated_at: Time.utc
    )

    user.can?(:create, user).should be_true
    user.can?(:create, user_2).should be_true
    user.can?(:create, User).should be_true

    user.can?(:delete, user).should be_true
    user.can?(:delete, user_2).should be_true
    user.can?(:delete, User).should be_true

    user.can?(:read, user).should be_true
    user.can?(:read, user_2).should be_true
    user.can?(:read, User).should be_true

    user.can?(:update, user).should be_true
    user.can?(:update, user_2).should be_true
    user.can?(:update, User).should be_true
  end

  it "disallows user from performing action" do
    user = User.new(
      id: 1_i64,
      created_at: Time.utc,
      email: "user@example.tld",
      level: User::Level.new(:author).to_i,
      password_hash: Login.hash_bcrypt("password_1Apassword"),
      updated_at: Time.utc
    )

    user_2 = User.new(
      id: 2_i64,
      created_at: Time.utc,
      email: "user_2@example.tld",
      level: User::Level.new(:editor).to_i,
      password_hash: Login.hash_bcrypt("password_1Apassword"),
      updated_at: Time.utc
    )

    user.can?(:create, user).should be_true
    user.can?(:create, user_2).should be_false
    user.can?(:create, User).should be_false

    user.can?(:delete, user).should be_false
    user.can?(:delete, user_2).should be_false
    user.can?(:delete, User).should be_false

    user.can?(:read, user).should be_true
    user.can?(:read, user_2).should be_false
    user.can?(:read, User).should be_false

    user.can?(:update, user).should be_true
    user.can?(:update, user_2).should be_false
    user.can?(:update, User).should be_false
  end
end
