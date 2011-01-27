require 'typhoeus'

module Animoto
  module HTTPEngines
    class TyphoeusAdapter < Animoto::HTTPEngines::Base
      
      # @return [String]
      def request method, url, body = nil, headers = {}, options = {}
        response = ::Typhoeus::Request.run(url, {
          :method => method,
          :body => body,
          :headers => headers,
          :timeout => options[:timeout],
          :username => options[:username],
          :password => options[:password]
        })
        [response.code, response.body]
      end   
    end    
  end
end