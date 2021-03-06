require 'curl'

module Animoto
  module HTTPEngines
    class CurlAdapter < Animoto::HTTPEngines::Base

      def initialize

      end

      # @return [String]
      def request method, url, body = nil, headers = {}, options = {}
        curl = build_curl method, url, body, headers, options
        perform curl, method, body
        [curl.response_code, curl.body_str, curl.header_str, curl]
      end

      private

      def curl_instance url
        if @curleasy.nil?
          @curleasy = ::Curl::Easy.new(url)
        else
          @curleasy.reset
          @curleasy.url = url
        end
        yield @curleasy
      end

      # Creates a Curl::Easy object with the headers, options, body, etc. set.
      #
      # @param [Symbol] method the HTTP method
      # @param [String] url the URL to request
      # @param [String,nil] body the request body
      # @param [Hash{String=>String}] headers hash of HTTP request headers
      # @return [Curl::Easy] the Easy instance
      def build_curl method, url, body, headers, options
        curl_instance(url) do |c|
          c.http_auth_types = Curl::CURLAUTH_BASIC
          c.post_body = body
          c.ssl_verify_host = false
          c.ssl_verify_peer = false
          options.each do |option, value|
            case option
              when :proxy #backwards compatibility with :proxy option
                c.proxy_url = value
              else
                c.send("#{option}=", value)
              end
          end
          headers.each { |header, value| c.headers[header] = value }
          c
        end
      end
      
      # Performs the request.
      #
      # @param [Curl::Easy] curl the Easy object with the request parameters
      # @param [Symbol] method the HTTP method to use
      # @param [String] body the HTTP request body
      # @return [void]
      def perform curl, method, body
        case method
        when :head
          curl.http_head
        when :get
          unless body.nil?
            curl.url += "?#{body}"
          end
          curl.http_get
        when :post
          curl.http_post(body)
        when :put
          curl.http_put(body)
        when :delete
          curl.http_delete
        end
      end
    end    
  end
end