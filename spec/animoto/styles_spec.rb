require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Animoto::Styles do
  describe "deprecated constants" do
    it "should warn you when using a deprecated constant name" do
      Animoto::Styles.expects(:warn)
      Animoto::Styles::ORIGINAL
    end

    it "should inform you of the new constant name" do
      const = Animoto::Styles::DEPRECATED_NAMES[:ORIGINAL].to_s
      Animoto::Styles.expects(:warn).with(regexp_matches(Regexp.compile(const)))
      Animoto::Styles::ORIGINAL
    end

    it "should return the correct value of the new constant name" do
      Animoto::Styles.stubs(:warn)
      Animoto::Styles::ORIGINAL.should == Animoto::Styles::ANIMOTO_ORIGINAL
    end

    it "should define the deprecated constant to suppress multiple warnings" do
      Animoto::Styles.expects(:warn).once
      Animoto::Styles.const_defined?(:ORIGINAL).should_not be_true
      Animoto::Styles::ORIGINAL
      Animoto::Styles.const_defined?(:ORIGINAL).should be_true
      Animoto::Styles::ORIGINAL
    end

    after do
      Animoto::Styles.__send__(:remove_const, :ORIGINAL) if Animoto::Styles.const_defined?(:ORIGINAL)
    end
  end
end
