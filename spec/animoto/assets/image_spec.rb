require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::Image do
  
  describe "initialization" do
    before do
      @image = Animoto::Assets::Image.new 'http://website.com/image.png',
        :rotation => 2, :spotlit => true, :cover => true, :caption => 'This is my caption'
    end
    
    it "should set the source to the given url" do
      @image.source.should == 'http://website.com/image.png'
    end
    
    it "should set the rotation to the given amount" do
      @image.rotation.should == 2
    end
    
    it "should set the spotlighting to the given value" do
      @image.should be_spotlit
    end
    
    it "should set the cover to the given value" do
      @image.should be_a_cover
    end

    it "should set the caption to the given text" do
      @image.caption.should == 'This is my caption'
    end
  end

  describe "#to_hash" do
    before do
      @image = Animoto::Assets::Image.new 'http://website.com/image.png'
    end
    
    it "should have a 'source_url' key with the url" do
      @image.to_hash.should have_key('source_url')
      @image.to_hash['source_url'].should == @image.source
    end
    
    describe "if rotated" do
      before do
        @image.rotation = 2
      end
      
      it "should have a 'rotation' key with the rotation value" do
        @image.to_hash.should have_key('rotation')
        @image.to_hash['rotation'].should == @image.rotation
      end
    end
    
    describe "if spotlit" do
      before do
        @image.spotlit = true
      end
      
      it "should have a 'spotlit' key telling whether or not this image is spotlit" do
        @image.to_hash.should have_key('spotlit')
        @image.to_hash['spotlit'].should == @image.spotlit?
      end
    end
    
    describe "if this image is the cover" do
      before do
        @image.cover = true
      end
      
      it "should have a 'cover' key telling whether or not this image is the cover" do
        @image.to_hash.should have_key('cover')
        @image.to_hash['cover'].should == @image.cover?
      end
    end

    describe "if caption is given" do
      before do
        @image.caption = "This is my caption"
      end

      it "it should have a 'caption' key with the caption value" do
        @image.to_hash.should have_key('caption')
        @image.to_hash['caption'].should == @image.caption
      end
    end

  end
end
