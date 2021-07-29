module Shield::PageUrlSession
  macro included
    include Shield::Session

    def previous_page_url : String
      previous_page_url?.not_nil!
    end

    def previous_page_url? : String?
      @session.get?(:previous_page_url).try do |url|
        delete
        url
      end
    end

    def delete : self
      @session.delete(:previous_page_url)
      self
    end

    def set(request : HTTP::Request) : self
      if request.method.in?({"GET", "HEAD"})
        set(request.resource)
      else
        delete
      end
    end

    def set(url : String) : self
      @session.set(:previous_page_url, url)
      self
    end
  end
end
