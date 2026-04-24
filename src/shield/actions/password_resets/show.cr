module Shield::PasswordResets::Show
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == password_reset.user_id
    end

    # get "/password-resets/:password_reset_id" do
    #   html ShowPage, password_reset: password_reset
    # end

    getter password_reset : PasswordReset do
      PasswordResetQuery.find(password_reset_id)
    end
  end
end
