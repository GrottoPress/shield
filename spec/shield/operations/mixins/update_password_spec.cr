require "../../../spec_helper"

private class UpdateUser < User::SaveOperation
  permit_columns :email, :level
  attribute password : String

  include Shield::UpdatePassword
end

describe Shield::UpdatePassword do
  it "updates password" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password(password)

    UpdateUser.update(
      user,
      params(password: new_password),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true

      BcryptHash.new(new_password)
        .verify?(updated_user.password_digest)
        .should(be_true)
    end
  end

  it "does not update password if new password empty" do
    user = UserFactory.create

    UpdateUser.update(
      user,
      params(password: ""),
      current_login: nil
    ) do |operation, updated_user|
      operation.saved?.should be_true
      updated_user.password_digest.should eq(user.password_digest)
    end
  end

  it "logs out everywhere when password changes" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password(password)

    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true

    UpdateUser.update(
      user,
      params(password: new_password),
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      login_1.reload.status.active?.should be_false
      login_2.reload.status.active?.should be_false
    end
  end

  it "retains current login when password changes" do
    password = "password12U-password"
    new_password = "assword12U-passwor"

    user = UserFactory.create &.password(password)

    login_1 = LoginFactory.create &.user_id(user.id)
    login_2 = LoginFactory.create &.user_id(user.id)
    current_login = LoginFactory.create &.user_id(user.id)

    login_1.status.active?.should be_true
    login_2.status.active?.should be_true
    current_login.status.active?.should be_true

    UpdateUser.update(
      user,
      params(password: new_password),
      current_login: current_login
    ) do |operation, _|
      login_1.reload.status.active?.should be_false
      login_2.reload.status.active?.should be_false
      current_login.reload.status.active?.should be_true
    end
  end

  it "does not log other users out when password changes" do
    mary_email = "mary@example.tld"
    mary_password = "password12U-password"
    mary_new_password = "assword12U-passwor"

    john_email = "john@example.tld"
    john_password = "pasword12U-pasword"

    mary = UserFactory.create &.email(mary_email).password(mary_password)
    mary_login = LoginFactory.create &.user_id(mary.id)

    john = UserFactory.create &.email(john_email).password(john_password)
    john_login = LoginFactory.create &.user_id(john.id)

    mary_login.status.active?.should be_true
    john_login.status.active?.should be_true

    UpdateUser.update(
      mary,
      params(password: mary_new_password),
      current_login: nil
    ) do |operation, _|
      operation.saved?.should be_true

      mary_login.reload.status.active?.should be_false
      john_login.reload.status.active?.should be_true
    end
  end
end
