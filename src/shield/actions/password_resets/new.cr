module Shield::PasswordResets::New
  macro included
    skip :require_logged_in

    authorize { true }

    # get "/password-resets/new" do
    #   operation = StartPasswordReset.new(remote_ip: remote_ip?)
    #   html NewPage, operation: operation
    # end
  end
end
