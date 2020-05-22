annotation Memoize
end

class Object
  macro method_added(method)
    {% if method.annotation(Memoize) %}
      memoize method
    {% end %}
  end
end

module MailHelpers
  def mail(email : Carbon::Email.class, *args, **kwargs) : Nil
    email.new(*args, **kwargs).deliver
  end

  def mail_later(email : Carbon::Email.class, *args, **kwargs) : Nil
    email.new(*args, **kwargs).deliver_later
  end
end

class String
  # Source: https://github.com/amberframework/amber/blob/master/src/amber/extensions/string.cr
  def email? : Bool
    !!match(/^[_]*([a-z0-9]+(\.|_*)?)+@([a-z][a-z0-9-]+(\.|-*\.))+[a-z]{2,6}$/)
  end
end

module Lucky
  module MountComponent
    def mount(component : Lucky::BaseComponent.class, *args, **kwargs) : Nil
      mount component.new(*args, **kwargs)
    end

    def mount(component : Lucky::BaseComponent.class, *args, **kwargs) : Nil
      mount component.new(*args, **kwargs) do |*yield_args|
        yield *yield_args
      end
    end
  end

  abstract class Action
    include MailHelpers
  end
end

class Avram::Operation
  include MailHelpers
end

macro avram_enum(enum_name, &block)
  enum Avram{{enum_name}}
    {{block.body}}
  end

  struct {{enum_name}}
    def self.adapter
      Lucky
    end

    # You may need to prefix with {{@type}}
    #
    #   {{@type}}::{{enum_name}}
    def initialize(@enum : Avram{{enum_name}})
    end

    def initialize(enum_value : Int32)
      @enum = Avram{{enum_name}}.from_value(enum_value)
    end

    def initialize(enum_value : String)
      @enum = Avram{{enum_name}}.from_value(enum_value.to_i)
    end

    forward_missing_to @enum

    module Lucky
      alias ColumnType = Int32

      include Avram::Type

      def from_db!(value : Int32)
        {{enum_name}}.new(value)
      end

      def parse(value : {{enum_name}})
        SuccessfulCast({{enum_name}}).new(value)
      end

      def parse(value : String)
        SuccessfulCast({{enum_name}}).new({{enum_name}}.new(value.to_i))
      end

      def parse(value : Int32)
        SuccessfulCast({{enum_name}}).new({{enum_name}}.new(value))
      end

      def to_db(value : Int32)
        value.to_s
      end

      def to_db(value : {{enum_name}})
        value.value.to_s
      end

      class Criteria(T, V) < Int32::Lucky::Criteria(T, V)
      end
    end
  end
end

struct Socket::IPAddress
  def self.adapter
    Lucky
  end

  def ip4? : Bool
    ip4? address
  end

  def ip6? : Bool
    ip6? address
  end

  module Lucky
    alias ColumnType = String

    include Avram::Type

    def from_db!(value : String)
      port = value.match /[^:\]]*$/
      address = value.rchop port.to_s

      IPAddress.new(address, port.try(&.[0].to_i) || 0)
    end

    def parse(value : IPAddress)
      SuccessfulCast(IPAddress).new(value)
    end

    def parse(value : String)
      SuccessfulCast(IPAddress).new(IPAddress.parse(value))
    rescue
      FailedCast.new
    end

    def to_db(value : String)
      value
    end

    def to_db(value : IPAddress)
      value.to_s
    end

    class Criteria(T, V) < String::Lucky::Criteria(T, V)
    end
  end
end
