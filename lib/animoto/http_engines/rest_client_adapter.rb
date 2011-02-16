require 'restclient'

module Animoto
  module HTTPEngines
    class RestClientAdapter < Animoto::HTTPEngines::Base
      
      # @return [String]
      def request method, url, body = nil, headers = {}, options = {}
        RestClient.proxy = options[:proxy]
        response = ::RestClient::Request.execute({
          :method => method,
          :url => url,
          :headers => headers,
          :payload => body,
          :user => options[:username],
          :password => options[:password],
          :timeout => options[:timeout]
        })
        [response.code, response.body]
      end
    end    
  end
end