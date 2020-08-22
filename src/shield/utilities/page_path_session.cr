module Shield::PagePathSession
  macro included
    def current_page_path! : String
      current_page_path.not_nil!
    end

    def previous_page_path! : String
      previous_page_path.not_nil!
    end

    def current_page_path : String?
      @session.get?(:current_page_path)
    end

    def previous_page_path : String?
      @session.get?(:previous_page_path)
    end

    def delete : self
      @session.delete(:previous_page_path)
      @session.delete(:current_page_path)
      self
    end

    def set(request : HTTP::Request) : self
      set(request.resource) if request.method.in?({"GET", "HEAD"})
      self
    end

    def set(path : String) : self
      return self if current_page_path == path
      @session.set(:previous_page_path, current_page_path.to_s)
      @session.set(:current_page_path, path)
      self
    end
  end
end
