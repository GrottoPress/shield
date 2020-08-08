module Shield::PreviousPageSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def previous_page_url! : String
      previous_page_url.not_nil!
    end

    def previous_page_url : String?
      @session.get?(:previous_page_url)
    end

    def delete : self
      @session.delete(:previous_page_url)
      self
    end

    def set(url : String) : self
      @session.set(:previous_page_url, url)
      self
    end
  end
end
