module Shield::SetUserIdFromUser
  macro included
    needs user : User?

    before_save do
      set_user_id
      validate_user_exists
    end

    def user!
      user || user_id.value.try { |value| UserQuery.new.id(value).first? }
    end

    private def set_user_id
      user.try do |user|
        user_id.value = user.id
      end
    end

    private def validate_user_exists
      return unless user_id.changed?
      return if user

      validate_foreign_key user_id,
        query: UserQuery,
        message: Rex.t(
          :"operation.error.user_not_found",
          user_id: user_id.value
        )
    end
  end
end
