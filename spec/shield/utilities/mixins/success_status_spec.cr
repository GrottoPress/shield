require "../../../spec_helper"

describe SuccessStatus do
  it "returns success status" do
    user = UserFactory.create

    password_reset = PasswordResetFactory.create &.user_id(user.id)
      .success(true)

    password_reset.success_status.to_s.should eq("success")
  end

  it "returns ongoing status" do
    user = UserFactory.create

    password_reset = PasswordResetFactory.create &.user_id(user.id)
      .success(false)

    password_reset.success_status.to_s.should eq("ongoing")
  end

  it "returns failure status" do
    user = UserFactory.create

    password_reset = PasswordResetFactory.create &.user_id(user.id)
      .inactive_at(Time.utc)
      .success(false)

    password_reset.success_status.to_s.should eq("failure")
  end
end
