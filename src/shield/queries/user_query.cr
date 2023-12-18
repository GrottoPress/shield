module Shield::UserQuery
  macro included
    def email(value : String)
      email.lower.eq(value.downcase)
    end
  end
end
