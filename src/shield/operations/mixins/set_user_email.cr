module Shield::SetUserEmail
  macro included
    getter? user_email = false

    before_save do
      set_user_email
    end

    private def set_user_email
      email.value.try do |value|
        query = UserQuery.new
        record.try { |_record| query = query.id.not.eq(_record.id) }
        @user_email = query.email.lower.eq(value.downcase).any?
      end
    end
  end
end
