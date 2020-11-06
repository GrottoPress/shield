module Shield::ActionPipes
  macro included
    def set_previous_page_url
      PageUrlSession.new(session).set(request)
      continue
    end

    @[Memoize]
    def previous_page_url
      PageUrlSession.new(session).previous_page_url
    end

    @[Memoize]
    def return_url
      ReturnUrlSession.new(session).return_url
    end

    def redirect_back(
      *,
      fallback : String,
      status : Int32 = 302,
      allow_external = false
    )
      url = return_url || previous_page_url || fallback
      redirect to: url, status: status
    end
  end
end
