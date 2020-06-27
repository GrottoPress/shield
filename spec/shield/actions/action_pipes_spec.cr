require "../../spec_helper"

describe Shield::ActionPipes do
  describe "#set_previous_page" do
    it "sets previous page" do
      client = AppClient.new

      response = client.exec(Home::Index)
      body(response)["page"].should eq("Home::Index")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(Home::New)
      body(response)["page"].should eq("Home::New")

      client.headers("Cookie": response.headers["Set-Cookie"]?)
      response = client.exec(About::Index)
      body(response)["page"].should eq("About::Index")

      body(response)["previous_page"].should eq(Home::Index.path)
    end
  end

  # describe "#redirect_back" do
  #   it "redirects back action" do

  #   end
  # end
end
