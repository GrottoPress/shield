require "../../spec_helper"

describe Shield::UpdatePassword do
  it "requires password" do
    user = UserFactory.create

    UpdatePassword.update(user) do |operation, _|
      operation.saved?.should be_false

      operation.password.should have_error("operation.error.password_required")
    end
  end
end
