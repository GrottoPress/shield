module Shield::PasswordResets::New
  macro included
    skip :require_logged_in

    # get "/password-resets/new" do
    #   operation = StartPasswordReset.new(params, remote_ip: remote_ip)
    #   html NewPage, operation: operation
    # end
  end
end
