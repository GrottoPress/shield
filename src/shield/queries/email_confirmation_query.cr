module Shield::EmailConfirmationQuery
  macro included
    include Lucille::SuccessStatusQuery

    def email(value : String)
      email.lower.eq(value.downcase)
    end
  end
end
