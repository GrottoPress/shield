module Shield::NewLogin
  macro included
    # get "/log-in" do
    #   html NewPage
    # end

    skip :require_logged_in
    before :require_logged_out
  end
end
