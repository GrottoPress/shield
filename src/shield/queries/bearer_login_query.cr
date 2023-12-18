module Shield::BearerLoginQuery
  macro included
    include Lucille::StatusQuery

    def name(value : String)
      name.lower.eq(value.downcase)
    end
  end
end
