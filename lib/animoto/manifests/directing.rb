require 'animoto/styles'
require 'animoto/postroll'
require 'animoto/postrolls/custom_footage'

module Animoto
  module Manifests
    class Directing < Animoto::Manifests::Base

      # The title of the video project.
      # @return [String]
      attr_accessor :title
      
      # The pacing, representing how quickly the visuals elements will be cycled.
      # Valid values are 'very_slow', 'slow', 'moderate', 'fast', 'very_fast' and 'auto'.
      # Faster songs will naturally cycle through images faster than slower songs. The
      # 'moderate' pacing is about 4 beats per image. With 'auto', Animoto's cinematic
      # artificial intelligence will decide what pacing will be best. The default pacing
      # is 'auto'.
      # @return [String]
      attr_accessor :pacing

      # The array of visual objects in this manifest.
      # @return [Array<Assets::Base,Assets::TitleCard>]
      attr_reader   :visuals
      
      # The song for this video.
      # @return [Assets::Song]
      attr_reader   :song
      
      # The 'style' for this video. Available styles are listed in {Animoto::Styles}.
      # Your partner account might have different styles available from those listed.
      # @return [String]
      attr_accessor :style

      # The 'postroll' for this video. Postrolls are the short video 'outro' segements
      # that play when the main video is finished.
      # @return [Animoto::Postroll]
      attr_reader   :postroll

      # Creates a new directing manifest.
      #
      # @param [Hash{Symbol=>Object}] options
      # @option options [String] :title the title of this project
      # @option options [String] :pacing ('auto') the pacing for this project
      # @option options [String,Animoto::Postroll] :postroll the postroll for this project
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      # @return [Manifests::Directing] the manifest
      def initialize options = {}
        super
        @title      = options[:title]
        @pacing     = options[:pacing]  || 'auto'
        @style      = options[:style]   || Animoto::Styles::ORIGINAL
        @postroll   = Animoto::Postroll.new(options[:postroll] || Animoto::Postroll::POWERED_BY_ANIMOTO)
        @visuals    = []
        @song       = nil
      end

      # Adds a TitleCard to this manifest.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the TitleCard
      # @return [Assets::TitleCard] the new TitleCard
      # @see Animoto::Assets::TitleCard#initialize
      def add_title_card *args
        card = Assets::TitleCard.new(*args)
        @visuals << card
        card
      end
    
      # Adds an Image to this manifest.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the Image
      # @return [Assets::Image] the new Image
      # @see Animoto::Assets::Image#initialize
      def add_image *args
        image = Assets::Image.new(*args)
        @visuals << image
        image
      end
    
      # Adds Footage to this manifest.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the Footage
      # @return [Assets::Footage] the new Footage
      # @see Animoto::Assets::Footage#initialize
      def add_footage *args
        footage = Assets::Footage.new(*args)
        @visuals << footage
        footage
      end
    
      # Adds a Song to this manifest. Right now, a manifest can only have one song. Adding
      # a second replaces the first.
      #
      # @param [Array<Object>] args arguments sent to the initializer for the Song
      # @return [Assets::Song] the new Song
      # @see Animoto::Assets::Song#initialize
      def add_song *args
        @song = Assets::Song.new(*args)
      end

      # Adds a visual/song to this manifest.
      #
      # @param [Assets::Base,Assets::TitleCard] asset the asset to add
      # @return [void]
      # @raise [ArgumentError] if the asset isn't a Song, Image, Footage, or TitleCard
      def add_visual asset
        case asset
        when Animoto::Assets::Song
          @song = asset
        when Animoto::Assets::Base, Animoto::Assets::TitleCard
          @visuals << asset
        else
          raise ArgumentError
        end      
      end

      # Adds a visual/song to this manifest.
      #
      # @param [Assets::Base,Assets::TitleCard] asset the asset to add
      # @return [self]
      def << asset
        add_visual asset
        self
      end

      # Sets the postroll for this project.
      #
      # @param [String,Animoto::Postroll] roll a postroll object or the postroll's template name
      # @return [Animoto::Postroll]
      def postroll= roll
        @postroll = Animoto::Postroll.new(roll)
      end

      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash{String=>Object}] the manifest as a Hash
      # @raise [ArgumentError] if a callback URL is specified but not the format
      def to_hash options = {}
        hash = { 'directing_job' => { 'directing_manifest' => {} } }
        job  = hash['directing_job']
        add_callback_information job
        manifest              = job['directing_manifest']
        manifest['style']     = style
        manifest['pacing']    = pacing if pacing
        manifest['postroll']  = postroll.to_hash if postroll
        manifest['title']     = title if title
        manifest['visuals']   = []
        visuals.each do |visual|
          manifest['visuals'] << visual.to_hash
        end
        manifest['song'] = song.to_hash if song
        hash
      end
    end
  end
end
