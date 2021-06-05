require "../spec_helper"

describe Shield::FakeNestedParams do
  it "encodes time into value acceptable by the time adapter" do
    time = Time.local(Time::Location.load "Europe/Berlin")
    params = nested_params(user: {created_at: time})
    created_at = Time.adapter.parse!(params.nested(:user)["created_at"])
    created_at.should eq(time.at_beginning_of_second)
  end
end
