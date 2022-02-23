module Shield::Logins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/logins" do
    #   html IndexPage, logins: logins, pages: pages
    # end

    def pages
      paginated_logins[0]
    end

    getter logins : Array(Login) do
      paginated_logins[1].results
    end

    private getter paginated_logins : Tuple(Lucky::Paginator, LoginQuery) do
      paginate LoginQuery.new.is_active.preload_user.active_at.desc_order
    end
  end
end
