module Shield::CurrentLogin::New
  macro included
    skip :require_logged_in

    authorize { true }

    # get "/login" do
    #   operation = StartCurrentLogin.new(remote_ip: remote_ip?, session: session)
    #   html NewPage, operation: operation
    # end
  end
end
