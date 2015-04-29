module Animoto
  module Assets
    class Image < Animoto::Assets::Base
      # The number of clockwise 90-degree rotations that should be applied to this image.
      # @return [Integer]
      attr_accessor :rotation
      
      # Whether or not this image is spotlit. Spotlighting a visual tells to director to add
      # more emphasis to this visual when directing.
      # @return [Boolean]
      attr_writer :spotlit
      
      # Returns whether or not this image is spotlit.
      # @return [Boolean]
      def spotlit?
        @spotlit
      end
      
      # Whether or not this image is the cover of the video. If this image is the video's cover,
      # the cover image will be generated using this image.
      # @return [Boolean]
      attr_writer :cover
      
      # Returns whether or not this footage is marked as the cover.
      # @return [Boolean]
      def cover?
        @cover
      end

      # Whether or not this image has a caption. If a caption is added, it will appear with the
      # image in the video.
      # @return [String]
      attr_accessor :caption

      # Creates a new Image object.
      #
      # @param [String] source the source URL of this image
      # @param [Hash{Symbol=>Object}] options
      # @option options [Integer] :rotation the number of clockwise 90-degree rotations to apply to this image
      # @option options [Boolean] :spotlit whether or not to spotlight this image
      # @option options [Boolean] :cover whether or not to generate the cover of this video from this image
      # @option options [String] :caption the text that should be displayed with the image
      # @return [Assets::Image] the Image object
      def initialize source, options = {}
        super
        @rotation = options[:rotation]
        @spotlit  = options[:spotlit]
        @cover    = options[:cover]
        @caption = options[:caption]
      end
      
      # Returns a representation of this Image as a Hash.
      #
      # @return [Hash{String=>Object}] this asset as a Hash
      # @see Animoto::Assets::Base#to_hash
      def to_hash
        hash = super
        hash['rotation'] = rotation if rotation
        hash['spotlit'] = spotlit? unless @spotlit.nil?
        hash['cover'] = cover? unless @cover.nil?
        hash['caption'] = caption unless @caption.nil?
        hash
      end
    end
  end
end
