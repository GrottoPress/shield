module Shield::Api::PasswordResets::Show
  macro included
    skip :require_logged_out

    # get "/password-resets/:password_reset_id" do
    #   json PasswordResetSerializer.new(password_reset: password_reset)
    # end

    getter password_reset : PasswordReset do
      PasswordResetQuery.find(password_reset_id)
    end

    def authorize?(user : Shield::User) : Bool
      super || user.id == password_reset.user_id
    end
  end
end
