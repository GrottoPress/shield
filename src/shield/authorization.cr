module Shield::Authorization
  macro included
    @@authorization = Hash(
      Shield::AuthorizedAction,
      Proc(Shield::User, Shield::Model?, Bool)
    ).new

    def self.authorize(
      *actions : Shield::AuthorizedAction,
      &rule : Proc(Shield::User, Shield::Model?, Bool)
    ) : Nil
      actions.each { |action| @@authorization[action] = rule }
    end

    def allow?(user : Shield::User, action : Shield::AuthorizedAction) : Bool
      return false unless rule = @@authorization[action]?
      rule.not_nil!.call(user, self)
    end

    def self.allow?(
      user : Shield::User,
      action : Shield::AuthorizedAction
    ) : Bool
      return false unless rule = @@authorization[action]?
      rule.not_nil!.call(user, nil)
    end
  end
end
