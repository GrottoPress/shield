module Shield::ActionPipes
  macro included
    def set_previous_page_path
      PagePathSession.new(session).set(request)
      continue
    end

    def previous_page_path
      PagePathSession.new(session).previous_page_path
    end

    def redirect_back(
      *,
      fallback : String,
      status : Int32 = 302,
      allow_external = false
    )
      # TODO: Pass `allow_external` to `super` in Lucky 0.24.0
      return super(fallback: fallback, status: status) if allow_external
      redirect to: (previous_page_path || fallback), status: status
    end
  end
end
