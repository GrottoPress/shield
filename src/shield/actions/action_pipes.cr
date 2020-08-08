module Shield::ActionPipes
  macro included
    def set_previous_page_url
      if request.method.in?({"GET", "HEAD"})
        PreviousPageSession.new(session).set(request.resource)
      end

      continue
    end

    def previous_page_url
      PreviousPageSession.new(session).previous_page_url
    end

    def redirect_back(*, fallback : String, status : Int32 = 302)
      redirect to: (previous_page_url || fallback), status: status
    end
  end
end
