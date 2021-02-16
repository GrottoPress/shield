require "./spec_helper"

private class ObjectWithMemoizedMethods
  getter times_method_1_called = 0

  @[Memoize]
  def method_1 : String
    @times_method_1_called += 1
    "method_1"
  end
end

describe Memoize do
  it "works" do
    object = ObjectWithMemoizedMethods.new

    object.method_1.should eq "method_1"
    2.times { object.method_1.should eq("method_1") }
    object.times_method_1_called.should eq 1
  end
end

describe ".__enum" do
  it "works with queries" do
    UserFactory.create &.level(User::Level.new :admin)

    UserQuery.new.level(:admin).first?.should be_a(User)
  end
end
