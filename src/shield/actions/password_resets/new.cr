module Shield::PasswordResets::New
  macro included
    # get "/password-resets/new" do
    #   html NewPage
    # end

    skip :require_authorization
    skip :require_logged_in

    before :require_logged_out
  end
end
