require 'animoto/postroll'

module Animoto
  class Postroll
    class CustomFootage < Animoto::Postroll

      # The URL to a video to insert into this custom footage postroll.
      # @return [String]
      attr_accessor :source_url, :start_time, :duration

      # Creates a new postroll with custom footage at the supplied
      # URL.
      #
      # @param [String] source_url a url to a video file to be inserted into
      #   this custom postroll template
      # @return [Animoto::Postroll::CustomFootage]
      def initialize source_url
        super("custom_footage")
        @source_url = source_url
      end

      # Returns a representation of this postroll as a hash.
      #
      # @return [Hash{String=>Object}]
      def to_hash
        super.merge({'source_url' => source_url, 'start_time' => start_time, 'duration' => duration})
      end
    end
  end
end
