module Shield::ActionHelpers
  macro included
    def previous_page_url
      previous_page_url?.not_nil!
    end

    getter? previous_page_url : String? do
      PageUrlSession.new(session).previous_page_url?
    end

    def return_url
      return_url?.not_nil!
    end

    getter? return_url : String? do
      ReturnUrlSession.new(session).return_url?
    end

    def redirect_back(
      *,
      fallback : String,
      status : Int32 = 302,
      allow_external : Bool = false
    )
      if request.method.in?({"GET", "HEAD", "DELETE"})
        url = return_url? || previous_page_url? || fallback
      else
        url = return_url? || fallback
      end

      redirect to: url, status: status
    end
  end
end
