module Shield::EmailConfirmations::Show
  macro included
    skip :require_logged_out

    authorize_user do |user|
      super || user.id == email_confirmation.user_id
    end

    # get "/email-confirmations/:email_confirmation_id" do
    #   html ShowPage, email_confirmation: email_confirmation
    # end

    getter email_confirmation : EmailConfirmation do
      EmailConfirmationQuery.find(email_confirmation_id)
    end
  end
end
