module Shield::PageUrlSession
  macro included
    def initialize(@session : Lucky::Session)
    end

    def self.new(context : HTTP::Server::Context)
      new(context.session)
    end

    def previous_page_url : String
      previous_page_url?.not_nil!
    end

    def previous_page_url?(*, delete = false) : String?
      @session.get?(:previous_page_url).try do |url|
        self.delete if delete
        url
      end
    end

    def delete : self
      @session.delete(:previous_page_url)
      self
    end

    def set(request : HTTP::Request) : self
      if self.class.safe_method?(request)
        set(request.resource)
      else
        delete
      end
    end

    def set(url : String) : self
      @session.set(:previous_page_url, url)
      self
    end

    def self.safe_method?(request : HTTP::Request) : Bool
      request.method.in?({"GET", "HEAD"})
    end
  end
end
