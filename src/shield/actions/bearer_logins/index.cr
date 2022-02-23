module Shield::BearerLogins::Index
  # References:
  #
  # - https://luckyframework.org/guides/database/pagination
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/bearer-logins" do
    #   html IndexPage, bearer_logins: bearer_logins, pages: pages
    # end

    def pages
      paginated_bearer_logins[0]
    end

    getter bearer_logins : Array(BearerLogin) do
      paginated_bearer_logins[1].results
    end

    getter paginated_bearer_logins : Tuple(
      Lucky::Paginator,
      BearerLoginQuery
    ) do
      paginate BearerLoginQuery.new.is_active.preload_user.active_at.desc_order
    end
  end
end
