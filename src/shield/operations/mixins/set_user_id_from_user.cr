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
      return unless valid? && user_id.changed?
      validate_primary_key(user_id, query: UserQuery) unless user
    end
  end
end
