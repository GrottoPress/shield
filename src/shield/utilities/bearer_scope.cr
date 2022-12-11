module Shield::BearerScope
  macro included
    getter name : String

    def initialize(@name)
    end

    def self.new(action : Lucky::Action.class)
      new(action.name.gsub("::", '.').underscore)
    end

    def to_param : String
      to_s
    end

    def to_json(json : JSON::Builder)
      json.string(to_s)
    end

    def to_s(io : IO)
      io << @name
    end

    def self.action_scopes : Array(self)
      actions = \{{
        "#{Lucky::Action
          .all_subclasses
          .reject(&.abstract?)
          .select { |k| k < Shield::ApiAction }} of Lucky::Action.class".id
      }}

      actions.map { |action| new(action) }
    end
  end
end
