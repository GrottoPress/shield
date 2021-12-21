module Shield::SetUserEmail
  macro included
    getter? user_email = false

    before_save do
      set_user_email
    end

    private def set_user_email
      email.value.try do |value|
        query = UserQuery.new.email(value)
        record.try { |record| query = query.id.not.eq(record.id) }
        @user_email = query.any?
      end
    end
  end
end
