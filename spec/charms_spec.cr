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
  describe ".parse" do
    it "parses enum" do
      level = User::Level.new(:author)
      User::Level.adapter.parse!(level).should eq(level)
    end

    it "parses string" do
      level = User::Level.new(:author)
      User::Level.adapter.parse!("aUTHoR").should eq(level)
    end

    it "parses symbol" do
      level = User::Level.new(:author)
      User::Level.adapter.parse!(:aUTHoR).should eq(level)
    end

    it "parses array of enums" do
      levels = [User::Level.new(:author)]
      User::Level.adapter.parse!(levels).should eq(levels)
    end

    it "parses array of strings" do
      levels = [User::Level.new(:author)]
      User::Level.adapter.parse!(["author"]).should eq(levels)
    end

    it "parses array of symbols" do
      levels = [User::Level.new(:author)]
      User::Level.adapter.parse!([:author]).should eq(levels)
    end

    it "works with queries" do
      UserFactory.create &.level(:admin)
      UserQuery.new.level(:admin).first?.should be_a(User)
    end
  end

  describe ".to_db" do
    it "works" do
      level = User::Level.new(:author)

      User::Level.adapter.to_db!(level).should eq("Author")
      User::Level.adapter.to_db!([level, level]).should eq("{Author,Author}")
    end
  end
end
