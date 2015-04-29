require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Postroll::CustomFootage do

  describe "initialization" do
    before do
      @custom_footage = Animoto::Postroll::CustomFootage.new 'http://website.com/movie.mp4'
    end

    it "should set the source to the given url" do
      @custom_footage.source_url.should == 'http://website.com/movie.mp4'
    end

    it "should set the start time to the given time" do
      @custom_footage.start_time = 1.0
      @custom_footage.start_time.should == 1.0
    end

    it "should set the duration to the given length" do
      @custom_footage.duration = 5.0
      @custom_footage.duration.should == 5.0
    end
  end

  describe "#to_hash" do
    before do
      @custom_footage = Animoto::Postroll::CustomFootage.new 'http://website.com/movie.mp4'
    end

    it "should have a 'source_url' key with the url" do
      @custom_footage.to_hash.should have_key('source_url')
      @custom_footage.to_hash['source_url'].should == @custom_footage.source_url
    end 

    describe "if start_time or/and duration is given" do
      before do
        @custom_footage.start_time = 2.0
        @custom_footage.duration = 7.0
      end

      it "should have a 'start_time' key with the given start_time" do
        @custom_footage.to_hash.should have_key('start_time')
        @custom_footage.to_hash['start_time'].should == @custom_footage.start_time
      end
  
      it "should have a 'duration' key with the given duraiton" do
        @custom_footage.to_hash.should have_key('duration')
        @custom_footage.to_hash['duration'].should == @custom_footage.duration    
      end
    end
  end
end
