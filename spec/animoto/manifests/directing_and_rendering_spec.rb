require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Animoto::Manifests::DirectingAndRendering do
  
  def manifest options = {}
    @manifest ||= Animoto::Manifests::DirectingAndRendering.new options
  end
  
  describe "generating a hash" do
    before do
      manifest(:title => 'Funderful Wonderment', :pacing => 'double',
        :resolution => "720p", :framerate => 24, :format => 'flv')
      @image = manifest.add_image 'http://website.com/image.png'
      @title_card = manifest.add_title_card 'woohoo', 'this is awesome'
      @footage = manifest.add_footage 'http://website.com/movie.mp4'
      @song_obj = manifest.add_song 'http://website.com/song.mp3'
    end
    
    it "should have top-level 'directing_and_rendering_job' object" do
      manifest.to_hash.should have_key('directing_and_rendering_job')
      manifest.to_hash['directing_and_rendering_job'].should be_a(Hash)
    end

    describe "when the partner metadata is set" do
      before do
        manifest.partner_metadata = {'partner_user_id' => '234', 'commercial_use' => 'No'}
      end

      it "should have the HTTP callback URL in the job" do
        manifest.to_hash['directing_and_rendering_job'].should have_key('partner_metadata')
        manifest.to_hash['directing_and_rendering_job']['partner_metadata'].should == manifest.partner_metadata
      end
    end
    
    describe "when the callback url is set" do
      before do
        manifest.http_callback_url = 'http://website.com/callback'        
      end

      describe "but the callback format isn't" do
        it "should raise an error" do
          lambda { manifest.to_hash }.should raise_error(ArgumentError)
        end
      end
  
      describe "as well as the format" do
        before do
          manifest.http_callback_format = 'xml'
        end
    
        it "should have the HTTP callback URL in the job" do
          manifest.to_hash['directing_and_rendering_job'].should have_key('http_callback')
          manifest.to_hash['directing_and_rendering_job']['http_callback'].should == manifest.http_callback_url
        end

        it "should have the HTTP callback format in the job" do
          manifest.to_hash['directing_and_rendering_job'].should have_key('http_callback_format')
          manifest.to_hash['directing_and_rendering_job']['http_callback_format'].should == manifest.http_callback_format
        end
      end
    end

    it "should have a directing manifest attribute" do
      @manifest.directing_manifest.should be_an_instance_of(Animoto::Manifests::Directing)
    end
        
    it "should have a 'directing_manifest' object within the job" do
      manifest.to_hash['directing_and_rendering_job'].should have_key('directing_manifest')
      manifest.to_hash['directing_and_rendering_job']['directing_manifest'].should be_a(Hash)
    end
    
    describe "directing_manifest" do
      before do
        @directing_manifest = manifest.directing_manifest
      end
      
      it "should have been initialized with the :title and :pacing attributes from the initial initialization" do
        @directing_manifest.title.should == 'Funderful Wonderment'
        @directing_manifest.pacing.should == 'double'
      end
      
      it "should defer unknown methods to the directing manifest if the directing manifest responds to those methods" do
        manifest.should_not respond_to(:pacing)
        @directing_manifest.should respond_to(:pacing)
        @directing_manifest.expects(:pacing)
        manifest.pacing
      end
      
      describe "to hash" do
        before do
          @hash = manifest.to_hash['directing_and_rendering_job']['directing_manifest']
        end
      
        it "should have a 'style' key in the manifest" do
          @hash.should have_key('style')
          @hash['style'].should == manifest.style
        end
    
        it "should have a 'pacing' key in the manifest" do
          @hash.should have_key('pacing')
          @hash['pacing'].should == manifest.pacing
        end
    
        it "should have a 'visuals' key in the manifest" do
          @hash.should have_key('visuals')
        end
    
        it "should have a 'song' object in the manifest" do
          @hash.should have_key('song')
          @hash['song'].should be_a(Hash)
        end

        it "should not have a 'fitting' hash in the manifest" do
          @hash.should_not have_key('fitting')
        end

        describe "with a 'max_duration' option" do
          before do
            opts = {:title => 'Funderful Wonderment', :pacing => 'double', :resolution => "720p",
              :framerate => 24, :format => 'flv', :max_duration => '30'}
            @mfest = Animoto::Manifests::DirectingAndRendering.new(opts)
            @title_card = @mfest.add_title_card 'woohoo', 'this is awesome'
            @song_obj = @mfest.add_song 'http://website.com/song.mp3'
            @hash = @mfest.to_hash['directing_and_rendering_job']['directing_manifest']
          end

          it "should have a 'fitting' hash in the manifest" do
            @hash.should have_key('fitting')
          end

          it "should specify a max duration in the manifest" do
            @hash['fitting'].should have_key('max_duration')
            @hash['fitting']['max_duration'].should == '30'
          end

          it "should specify a type in the manifest" do
            @hash['fitting'].should have_key('type')
            @hash['fitting']['type'].should == 'best_fit'
          end
        end

        describe "visuals array" do
          before do
            @visuals = @hash['visuals']
          end
      
          it "should have the visuals in the order they were added" do
            @visuals[0].should == @image.to_hash
            @visuals[1].should == @title_card.to_hash
            @visuals[2].should == @footage.to_hash
          end
        end
    
        describe "song" do
          before do
            @song = @hash['song']
          end
      
          it "should have info about the song" do
            @song.should == @song_obj.to_hash
          end
        end
      end
    end

    it "should have a rendering manifest attribute" do
      manifest.rendering_manifest.should be_an_instance_of(Animoto::Manifests::Rendering)
    end

    it "should have a 'rendering_manifest' object within the job" do
      manifest.to_hash['directing_and_rendering_job'].should have_key('rendering_manifest')
      manifest.to_hash['directing_and_rendering_job']['rendering_manifest'].should be_a(Hash)
    end

    describe "rendering_manifest" do
      before do
        @rendering_manifest = manifest.rendering_manifest
      end
      
      it "should have been initialized with the :format, :framerate, and :resolution attributes from the initial initialization" do
        @rendering_manifest.format.should == 'flv'
        @rendering_manifest.framerate.should == 24
        @rendering_manifest.resolution.should == '720p'
      end
      
      it "should defer unknown methods to the rendering manifest if the rendering manifest responds to those methods" do
        manifest.should_not respond_to(:resolution)
        @rendering_manifest.should respond_to(:resolution)
        @rendering_manifest.expects(:resolution)
        manifest.resolution
      end

      describe "to hash" do
        before do
          @hash = manifest.to_hash['directing_and_rendering_job']['rendering_manifest']
        end
      
        it "should have a 'rendering_parameters' object in the manifest" do
          @hash.should have_key('rendering_parameters')
          @hash['rendering_parameters'].should be_a(Hash)
        end

        describe "rendering_parameters" do
          before do
            @profile = @hash['rendering_parameters']
          end

          it "should have a 'resolution' key" do
            @profile['resolution'].should == manifest.resolution
          end

          it "should have a 'framerate' key" do
            @profile['framerate'].should == manifest.framerate
          end

          it "should have a 'format' key" do
            @profile['format'].should == manifest.format
          end
        end
      end
    end
  end  
end
