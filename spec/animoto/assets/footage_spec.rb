require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::Footage do
  
  describe "initialization" do
    before do
      @footage = Animoto::Assets::Footage.new 'http://website.com/movie.mp4',
        :audio_mix => true, :start_time => 1.0, :duration => 5.0, :rotation => 3, :cover => true
    end
    
    it "should set the source to the given url" do
      @footage.source.should == 'http://website.com/movie.mp4'
    end
    
    it "should set the audio mix to the given value" do
      @footage.audio_mix.should be_true
    end
    
    it "should set the start time to the given time" do
      @footage.start_time.should == 1.0
    end
    
    it "should set the duration to the given length" do
      @footage.duration.should == 5.0
    end
    
    it "should set the rotation to the given amount" do
      @footage.rotation.should == 3
    end
    
    it "should set the cover to the given value" do
      @footage.should be_a_cover
    end
  end
  
  describe "#to_hash" do
    before do
      @footage = Animoto::Assets::Footage.new 'http://website.com/movie.mp4'
    end
    
    it "should have a 'source_url' key with the url" do
      @footage.to_hash.should have_key('source_url')
      @footage.to_hash['source_url'].should == @footage.source
    end
    
    describe "if audio mixing is turned on" do
      before do
        @footage.audio_mix = 'MIX'
      end
      
      it "should have an 'audio_mix' key telling how to mix" do
        @footage.to_hash.should have_key('audio_mix')
        @footage.to_hash['audio_mix'].should == 'MIX'
      end
    end
    
    describe "if using a different start time" do
      before do
        @footage.start_time = 10.5
      end
      
      it "should have a 'start_time' key with the starting time" do
        @footage.to_hash.should have_key('start_time')
        @footage.to_hash['start_time'].should == @footage.start_time
      end
    end
    
    describe "if a duration was specified" do
      before do
        @footage.duration = 300
      end
      
      it "should have a 'duration' key with the duration" do
        @footage.to_hash.should have_key('duration')
        @footage.to_hash['duration'].should == @footage.duration
      end
    end
    
    describe "if a rotation was given" do
      before do
        @footage.rotation = 3
      end
      
      it "should have a 'rotation' key with the rotation" do
        @footage.to_hash.should have_key('rotation')
        @footage.to_hash['rotation'].should == @footage.rotation
      end
    end
    
    describe "if this footage is the cover" do
      before do
        @footage.cover = true
      end
      
      it "should have a 'cover' key with telling whether or not this footage is the cover" do
        @footage.to_hash.should have_key('cover')
        @footage.to_hash['cover'].should == @footage.cover?
      end
    end
  end
end
