module Shield::ReturnUrlSession
  macro included
    def return_url! : String
      return_url.not_nil!
    end

    def return_url : String?
      @session.get?(:return_url)
    end

    def delete : self
      @session.delete(:return_url)
      self
    end

    def set(request : HTTP::Request) : self
      set(request.resource)
    end

    def set(url : String) : self
      @session.set(:return_url, url)
      self
    end
  end
end
