module Shield::EmailConfirmations::New
  macro included
    skip :require_logged_in

    # get "/email-confirmations/new" do
    #   html NewPage, operation: StartEmailConfirmation.new(params)
    # end
  end
end
