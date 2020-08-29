module Shield::PageUrlSession
  macro included
    def current_page_url! : String
      current_page_url.not_nil!
    end

    def previous_page_url! : String
      previous_page_url.not_nil!
    end

    def current_page_url : String?
      @session.get?(:current_page_url)
    end

    def previous_page_url : String?
      @session.get?(:previous_page_url)
    end

    def delete : self
      @session.delete(:previous_page_url)
      @session.delete(:current_page_url)
      self
    end

    def set(request : HTTP::Request) : self
      set(request.resource) if request.method.in?({"GET", "HEAD"})
      self
    end

    def set(url : String) : self
      return self if current_page_url == url
      @session.set(:previous_page_url, current_page_url.to_s)
      @session.set(:current_page_url, url)
      self
    end
  end
end
