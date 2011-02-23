module Animoto
  module Support
    module Hash
      
      # Returns a new hash with only the listed keys from this hash.
      #
      # @param [Array<Object>] keys the keys to include
      # @return [Hash{Object=>Object}] a new hash with only the listed keys
      def only *keys
        self.dup.delete_if { |k,v| !keys.include?(k) }
      end unless {}.respond_to?(:only)
      
      # Returns a new hash with all keys from this hash except the listed ones.
      #
      # @param [Array<Object>] keys the keys to exclude
      # @return [Hash{Object=>Object}] a new hash without the listed keys
      def except *keys
        self.dup.delete_if { |k,v| keys.include?(v) }
      end unless {}.respond_to?(:except)
      
    end
  end
end

Hash.__send__ :include, Animoto::Support::Hash