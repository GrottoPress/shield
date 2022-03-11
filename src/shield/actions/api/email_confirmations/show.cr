module Shield::Api::EmailConfirmations::Show
  macro included
    skip :require_logged_in
    skip :require_logged_out

    # get "/email-confirmations/:token" do
    #   json ItemResponse.new(email_confirmation: email_confirmation)
    # end

    def email_confirmation
      email_confirmation?.not_nil!
    end

    getter? email_confirmation : EmailConfirmation? do
      EmailConfirmationParams.new(params).email_confirmation?
    end

    def authorize?(user : Shield::User) : Bool
      user.id == current_user?.try &.id
    end
  end
end
