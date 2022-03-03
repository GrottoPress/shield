module Shield::Api::PasswordResets::Index
  macro included
    skip :require_logged_out

    # param page : Int32 = 1

    # get "/password-resets" do
    #   json({
    #     status: "success",
    #     data: {password_resets: PasswordResetSerializer.for_collection(
    #       password_resets
    #     )},
    #     pages: PaginationSerializer.new(pages)
    #   })
    # end

    def pages
      paginated_password_resets[0]
    end

    getter password_resets : Array(PasswordReset) do
      paginated_password_resets[1].results
    end

    private getter paginated_password_resets : Tuple(
      Lucky::Paginator,
      PasswordResetQuery
    ) do
      paginate PasswordResetQuery.new
        .is_active
        .preload_user
        .active_at.desc_order
    end
  end
end
