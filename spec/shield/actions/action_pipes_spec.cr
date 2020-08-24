require "../../spec_helper"

describe Shield::ActionPipes do
  describe "#set_previous_page_url" do
    it "sets previous page URL" do
      client = AppClient.new

      response = client.exec(Home::Index)
      body(response)["page"].should eq("Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(About::Index)
      body(response)["page"].should eq("About::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Create)
      body(response)["page"].should eq("Home::Create")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Index)
      body(response)["page"].should eq("Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Index)
      body(response)["page"].should eq("Home::Index")

      body(response)["previous_page"].should eq(About::Index.path)
    end
  end

  describe "#redirect_back" do
    it "redirects back" do
      client = AppClient.new

      response = client.exec(Home::Index)
      body(response)["page"].should eq("Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::Show)
      response.headers["Location"].should eq(Home::Index.path)
    end

    it "redirects back to external URL" do
      client = AppClient.new

      response = client.exec(Home::Index)
      body(response)["page"].should eq("Home::Index")

      referrer = "http://abc.def/gh"

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      client.headers("Referer": referrer)
      response = client.exec(Home::Edit)
      response.headers["Location"].should eq(referrer)
    end
  end
end
