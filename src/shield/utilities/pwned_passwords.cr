module Shield::PwnedPasswords
  macro included
    def initialize
      @client = HTTP::Client.new("api.pwnedpasswords.com", tls: true)
      set_request_headers
    end

    def self.pwned?(password)
      new.pwned?(password)
    end

    def pwned?(password : String) : Bool?
      digest = Digest::SHA1.hexdigest(password)
      first, last = digest[0, 5], digest[5..]
      connect_and_check(first, last)
    end

    private def set_request_headers
      @client.before_request do |request|
        request.headers["User-Agent"] = user_agent
      end
    end

    private def user_agent
      "Shield/#{Shield::VERSION} (+https://github.com/GrottoPress/shield)"
    end

    private def connect_and_check(first : String, last : String) : Bool?
      last = last.upcase
      retries = 5

      retries.times do |i|
        @client.get("/range/#{first}") do |response|
          if response.status.success?
            return response.body_io.each_line.any? &.starts_with?(last)
          end
        end

        sleep 1 unless i == (retries - 1)
      end
    end
  end
end
