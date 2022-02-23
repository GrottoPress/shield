module Shield::Api::Logins::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/logins" do
    #   json({
    #     status: "success",
    #     data: {logins: LoginSerializer.for_collection(logins)},
    #     pages: {
    #       current: page,
    #       total: pages.total
    #     }
    #   })
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
