require File.expand_path(File.dirname(__FILE__) + "/../../../spec_helper")

describe Animoto::Resources::Jobs::Rendering do
  
  it "should have endpoint '/jobs/rendering'" do
    Animoto::Resources::Jobs::Rendering.endpoint.should == '/jobs/rendering'
  end
  
  it "should have content type 'application/vnd.animoto.rendering_job'" do
    Animoto::Resources::Jobs::Rendering.content_type.should == 'rendering_job'
  end
  
  it "should have payload key 'rendering_job'" do
    Animoto::Resources::Jobs::Rendering.payload_key.should == 'rendering_job'
  end
  
  describe "loading from a response body" do
    before do
      @body = {
        'response' => {
          'status' => {
            'code' => 200
          },
          'payload' => {
            'rendering_job' => {
              'state' => 'completed',
              'links' => {
                'self' => 'http://animoto.com/jobs/rendering/1',
                'storyboard' => 'http://animoto.com/storyboards/1',
                'video' => 'http://animoto.com/videos/1',
                'stream' => 'http://animoto.com/streams/1.m3u8'
              }
            }
          }
        }
      }
      @job = Animoto::Resources::Jobs::Rendering.load @body
    end
    
    it "should set the storyboard url from the body" do
      @job.storyboard_url.should == "http://animoto.com/storyboards/1"
    end
    
    it "should set the video url from the body" do
      @job.video_url.should == "http://animoto.com/videos/1"
    end
    
    it "should create a storyboard from the storyboard url" do
      @job.storyboard.should be_an_instance_of(Animoto::Resources::Storyboard)
      @job.storyboard.url.should == @job.storyboard_url
    end
    
    it "should create a video from the video url" do
      @job.video.should be_an_instance_of(Animoto::Resources::Video)
      @job.video.url.should == @job.video_url
    end

    it "should set its stream url from the 'stream' link given" do
      @job.stream_url.should == 'http://animoto.com/streams/1.m3u8'
    end
  end
end
