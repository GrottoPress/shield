module Shield::CurrentLogin::New
  macro included
    skip :require_logged_in

    # get "/login" do
    #   operation = LogUserIn.new(params, remote_ip: remote_ip)
    #   html NewPage, operation: operation
    # end
  end
end
