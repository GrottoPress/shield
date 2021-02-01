require "./shield"

abstract class Lucky::BaseHTTPClient
  include Shield::HttpClient
end

class FakeNestedParams
  include Shield::FakeNestedParams
end

def assert_valid(attribute : Avram::Attribute)
  attribute.errors.should be_empty
end

def assert_valid(attribute : Avram::Attribute, text : String)
  attribute.errors.select(&.includes? text).should be_empty
end

def assert_valid(operation : Avram::Callbacks, key : Symbol)
  operation.errors[key]?.should be_nil
end

def assert_valid(operation : Avram::Callbacks, key : Symbol, text : String)
  operation.errors[key].select(&.includes? text).should be_empty
end

def assert_invalid(attribute : Avram::Attribute)
  attribute.errors.should_not be_empty
end

def assert_invalid(attribute : Avram::Attribute, text : String)
  attribute.errors.select(&.includes? text).size.should eq(1)
end

def assert_invalid(operation : Avram::Callbacks, key : Symbol)
  operation.errors[key]?.should_not be_nil
end

def assert_invalid(operation : Avram::Callbacks, key : Symbol, text : String)
  operation.errors[key].select(&.includes? text).size.should eq(1)
end

def params(**named_args)
  Avram::Params.new named_args.to_h
    .transform_keys(&.to_s)
    .transform_values &.to_s
end

def nested_params(**named_args)
  FakeNestedParams.new(**named_args)
end
