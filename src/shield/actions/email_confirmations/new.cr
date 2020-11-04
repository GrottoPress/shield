module Shield::EmailConfirmations::New
  macro included
    skip :require_logged_in

    # get "/email-confirmations/new" do
    #   operation = StartEmailConfirmation.new(remote_ip: remote_ip)
    #   html NewPage, operation: operation
    # end
  end
end
