module Shield::VerifyPasswordReset
  macro included
    needs session : Lucky::Session

    def submit
      yield self, submit
    end

    def submit!
      submit.not_nil!
    end

    def submit : PasswordReset?
      return unless password_reset.try &.status.started?
      expire_password_reset! && return nil if password_reset!.expired?
      password_reset! if authenticate?
    rescue
      nil
    end

    def authenticate? : Bool
      VerifyLogin.verify_sha256?(
        password_reset_token!,
        password_reset!.token_hash
      )
    rescue
      false
    end

    def password_reset! : PasswordReset
      password_reset.not_nil!
    end

    @[Memoize]
    def password_reset : PasswordReset?
      password_reset_id.try { |id| PasswordResetQuery.new.id(id.to_i64).first? }
    end

    def expire_password_reset!
      EndPasswordReset.update!(
        password_reset!,
        status: PasswordReset::Status.new(:expired)
      )
    end

    def set_session : Nil
      params.get?(:id).try { |id| session.set(:password_reset_id, id) }
      params.get?(:token).try do |token|
        session.set(:password_reset_token, token)
      end
    end

    def delete_session : Nil
      session.delete(:password_reset_id)
      session.delete(:password_reset_token)
    end

    def password_reset_id!
      password_reset_id.not_nil!
    end

    def password_reset_id
      session.get?(:password_reset_id)
    end

    def password_reset_token!
      password_reset_token.not_nil!
    end

    def password_reset_token
      session.get?(:password_reset_token)
    end
  end
end
