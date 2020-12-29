module Shield::BearerLoginHelper
  macro extended
    extend self

    def scope(action : Lucky::Action.class) : String
      action.name.gsub("::", '.').underscore
    end

    def all_scopes : Array(String)
      actions = {{
        Lucky::Action
          .all_subclasses
          .reject(&.abstract?)
          .select { |k| k < Shield::ApiAction }
      }} of Lucky::Action.class

      actions.map { |action| scope(action) }
    end
  end
end
