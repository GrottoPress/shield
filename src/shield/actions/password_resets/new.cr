module Shield::PasswordResets::New
  macro included
    skip :require_logged_in

    # get "/password-resets/new" do
    #   html NewPage, operation: StartPasswordReset.new(params)
    # end
  end
end
