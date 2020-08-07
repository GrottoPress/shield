module Shield::ActionPipes
  macro included
    def set_previous_page
      session.set(:previous_page, request.resource) if request.method == "GET"
      continue
    end

    def previous_page
      session.get?(:previous_page)
    end

    def redirect_back(*, fallback : String, status : Int32 = 302)
      redirect to: (previous_page || fallback), status: status
    end
  end
end
