require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe Animoto::Assets::TitleCard do
  
  describe "initialization" do
    before do
      @card = Animoto::Assets::TitleCard.new "hooray", "for everything", :spotlit => true
    end
    
    it "should set the title to the given string" do
      @card.title.should == 'hooray'
    end
    
    it "should set the subtitle to the given string" do
      @card.subtitle.should == 'for everything'
    end
    
    it "should set the spotlighting to the given value" do
      @card.should be_spotlit
    end
  end

  describe "#to_hash" do
    before do
      @card = Animoto::Assets::TitleCard.new("hooray")
    end
    
    it "should have type 'title_card'" do
      @card.to_hash.should have_key('type')
      @card.to_hash['type'].should == 'title_card'
    end

    it "should have an 'h1' key with the title" do
      @card.to_hash.should have_key('h1')
      @card.to_hash['h1'].should == @card.title
    end

    describe "if there is a subtitle" do
      before do
        @card.subtitle = "for everything!"
      end

      it "should have an 'h2' key with the subtitle" do
        @card.to_hash.should have_key('h2')
        @card.to_hash['h2'].should == @card.subtitle
      end
    end
    
    describe "if spotlit" do
      before do
        @card.spotlit = true
      end
      
      it "should have a 'spotlit' key telling whether or not it is spotlit" do
        @card.to_hash.should have_key('spotlit')
        @card.to_hash['spotlit'].should == @card.spotlit?
      end
    end
  end
  
end
