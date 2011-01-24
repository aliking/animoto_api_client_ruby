module Animoto
  module Manifests
    class Rendering < Animoto::Manifests::Base
    
      # The vertical resolution of the rendered video. Valid values are '180p', '270p',
      # '360p', '480p', '576p', '720p' or '1080p'.
      # @return [String]
      attr_accessor :resolution
      
      # The framerate of the rendered video. Valid values are 12, 15, 24 or 30.
      # @return [Integer]
      attr_accessor :framerate
      
      # The format of the rendered video. Valid values are 'h264', 'h264-iphone', 'flv' or 'iso'.
      # @return [String]
      attr_accessor :format
      
      # The storyboard this rendering targets.
      # @return [Resources::Storyboard]
      attr_accessor :storyboard
      
      # Creates a new rendering manifest.
      #
      # @param [Resources::Storyboard] storyboard the storyboard for this rendering
      # @param [Hash{Symbol=>Object}] options
      # @option options [String] :resolution the vertical resolution of the rendered video
      # @option options [Integer] :framerate the framerate of the rendered video
      # @option options [String] :format the format of the rendered video
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      # @return [Manifests::Rendering] the manifest
      def initialize *args
        options = args.last.is_a?(Hash) ? args.pop : {}
        super(options)
        @storyboard = args.shift
        @resolution = options[:resolution]
        @framerate  = options[:framerate]
        @format     = options[:format]
      end
    
      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash{String=>Object}] this manifest as a Hash
      # @raise [ArgumentError] if a callback URL was specified but not the format
      def to_hash
        hash  = { 'rendering_job' => { 'rendering_manifest' => { 'rendering_parameters' => {} } } }
        job   = hash['rendering_job']
        add_callback_information job
        manifest = job['rendering_manifest']
        manifest['storyboard_url'] = storyboard.url if storyboard
        params = manifest['rendering_parameters']
        params['resolution'] = resolution
        params['framerate'] = framerate
        params['format'] = format
        hash
      end    
    end
  end
end