module Shield::CurrentLogin::New
  macro included
    skip :require_logged_in

    # get "/login" do
    #   html NewPage, operation: LogUserIn.new(params)
    # end
  end
end
