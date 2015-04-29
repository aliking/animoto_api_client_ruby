module Animoto
  module Manifests

    # @abstract
    class Base
      include Support::ContentType
            
      # @return [String]
      def self.infer_content_type
        super + '_manifest'
      end
      
      # Returns the Resources::Jobs::Base descendant class associated with this manifest class
      # (that is, the type of job returned when a manifest of this type is posted).
      #
      # @example
      #   Manifests::Directing.associated_job_class # => Resources::Jobs::Directing
      # @return [Class] the associated job class
      def self.associated_job_class
        Resources::Jobs.const_get(self.name.split('::').last)
      end
    
      # A URL to receive a callback after directing is finished.
      # @return [String]
      attr_accessor :http_callback_url
      
      # The format of the callback; either 'xml' or 'json'.
      # @return [String]
      attr_accessor :http_callback_format

      attr_accessor :partner_metadata

      # Creates a new manifest
      #
      # @param [Hash{Symbol=>Object}] options
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      # @option options [String] :partner_metadata an array of hashes with a predefined format containing  
      #   the hashes for ['partner_user_id', 'commercial_use', 'partner_intent', 'application_data']
      #   where application_data is an array of hashes ['title', 'id', 'kind', 'type']
      def initialize options = {}
        @http_callback_url  = options[:http_callback_url]
        @http_callback_format = options[:http_callback_format]
        @partner_metadata  = options[:partner_metadata]
      end

      # Returns a representation of this manifest as a Hash, used to populate
      # request bodies when directing, rendering, etc.
      #
      # @return [Hash{String=>Object}] the manifest as a Hash
      def to_hash
        {}
      end
      
      # Returns the Resources::Jobs::Base descendant class associated with this manifest (that is,
      # the type of job that will be returned when this manifest is posted).
      #
      # @return [Class] the associated job class
      def associated_job_class
        self.class.associated_job_class
      end
      
      private

      # Helper method to put the partner_metadata into the manifest hash
      #
      # @param [Hash{String=>Object}] job_hash the hash version of the 'job' portion of this manifest
      # @return [void]
      def add_partner_metadata job_hash
        if partner_metadata
          job_hash['partner_metadata'] = partner_metadata
        end
      end
      
      # Helper method to put the standard HTTP callback information into the manifest hash
      #
      # @param [Hash{String=>Object}] job_hash the hash version of the 'job' portion of this manifest
      # @return [void]
      # @raise [ArgumentError] if a callback url is specified but not the format
      def add_callback_information job_hash
        if http_callback_url
          raise ArgumentError, "You must specify a http_callback_format (either 'xml' or 'json')" if http_callback_format.nil?
          job_hash['http_callback'] = http_callback_url
          job_hash['http_callback_format'] = http_callback_format
        end
      end
    end
  end
end
