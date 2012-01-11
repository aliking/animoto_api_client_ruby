require File.dirname(__FILE__) + '/../../spec_helper'

describe Animoto::HTTPEngines::CurlAdapter do
  describe "building a Curl request" do
    before do
      @engine = Animoto::HTTPEngines::CurlAdapter.new

    end
    
    it "should allow setting of arbitrary curl options" do
      curl = @engine.send(:build_curl, :post,
                         "http://example.com",
                         "bodytext",
                         {"Accept" => "text/html"},
                         {:username => "joe",
                         :password => "pass",
                         :timeout => 30,
                         :proxy => "http://webprox:8080",
                         :follow_location => true})
      curl.username == "joe"
      curl.password.should == "pass"
      curl.timeout.should == 30
      curl.proxy_url.should == "http://webprox:8080"
      curl.follow_location?.should == true
    end
  end

  
end