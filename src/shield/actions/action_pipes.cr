module Shield::ActionPipes
  macro included
    private def set_previous_page
      session.set(:previous_page, request.resource) if request.method == "GET"
      continue
    end

    private def previous_page
      session.get?(:previous_page)
    end

    private def redirect_back(
      *,
      fallback : Lucky::Action.class,
      status : HTTP::Status
    )
      redirect_back fallback: fallback, status: status.value
    end

    private def redirect_back(
      *,
      fallback : Lucky::RouteHelper,
      status : HTTP::Status
    )
      redirect_back fallback: fallback, status: status.value
    end

    private def redirect_back(*, fallback : String, status : Int32 = 302)
      redirect to: (previous_page || fallback), status: status
    end
  end
end
