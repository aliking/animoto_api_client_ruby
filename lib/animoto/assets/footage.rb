module Animoto
  module Assets
    class Footage < Animoto::Assets::Base
      # Whether or not to mix the audio of this footage with the video's soundtrack.
      # @return [Boolean]
      attr_accessor :audio_mix
      
      # The time in seconds of where to start extracting a clip from this footage to
      # add to the video.
      # @return [Float]
      attr_accessor :start_time
      
      # The duration in seconds of how long this footage should run in the video.
      # @return [Float]
      attr_accessor :duration
    
      # The number of clockwise 90-degree rotations that should be applied to this video.
      # @return [Integer]
      attr_accessor :rotation
      
      # Whether or not this footage is the cover of the video. If this piece of footage is
      # the video's cover, the cover image will be generated from a frame in this footage.
      # @return [Boolean]
      attr_writer :cover
      
      # Returns whether or not this footage is marked as the cover.
      # @return [Boolean]
      def cover?
        @cover
      end

      # Creates a new Footage object.
      #
      # @param [String] source the source URL of this footage
      # @param [Hash{Symbol=>Object}] options
      # @option options [Boolean] :audio_mix whether or not to mix the audio from this footage with the soundtrack of the video
      # @option options [Float] :start_time the offset in seconds from the beginning of where to start playing this footage
      # @option options [Float] :duration the length in seconds to play this footage
      # @option options [Integer] :rotation the number of clockwise 90-degree rotations to apply to this footage
      # @option options [Boolean] :cover whether or not to generate the cover of this video from this footage
      # @return [Assets::Footage] the Footage object
      def initialize source, options = {}
        super
        @audio_mix  = options[:audio_mix]
        @start_time = options[:start_time]
        @duration   = options[:duration]
        @rotation   = options[:rotation]
        @cover      = options[:cover]
      end

      # Returns a representation of this Footage as a Hash.
      #
      # @return [Hash{String=>Object}] this asset as a Hash
      # @see Animoto::Assets::Base#to_hash
      def to_hash
        hash = super
        hash['audio_mix'] = audio_mix if audio_mix
        hash['start_time'] = start_time if start_time
        hash['duration'] = duration if duration
        hash['rotation'] = rotation if rotation
        hash['cover'] = cover? unless @cover.nil?
        hash 
      end
    end
  end
end