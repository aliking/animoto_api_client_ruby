require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'yaml'

$:.unshift File.dirname(__FILE__)
require 'errors'
require 'content_type'
require 'standard_envelope'
require 'resource'
require 'asset'
require 'visual'
require 'footage'
require 'image'
require 'song'
require 'title_card'
require 'manifest'
require 'directing_manifest'
require 'rendering_manifest'
require 'directing_and_rendering_manifest'
require 'storyboard'
require 'video'
require 'job'
require 'directing_and_rendering_job'
require 'directing_job'
require 'rendering_job'

module Animoto
  class Client
    API_ENDPOINT      = "http://api2-staging.animoto.com/"
    API_VERSION       = 1
    BASE_CONTENT_TYPE = "application/vnd.animoto"
    HTTP_METHOD_MAP   = {
      :get  => Net::HTTP::Get,
      :post => Net::HTTP::Post
    }
    
    attr_accessor :key, :secret
    attr_reader   :format
    
    def initialize *args
      @debug = ENV['DEBUG']
      options = args.last.is_a?(Hash) ? args.pop : {}
      @key = args[0]
      @secret = args[1]
      unless @key && @secret
        home_path = File.expand_path '~/.animotorc'
        config = if File.exist?(home_path)
          YAML.load(File.read(home_path))
        elsif File.exist?('/etc/.animotorc')
          YAML.load(File.read('/etc/.animotorc'))
        end
        if config
          @key ||= config['key']
          @secret ||= config['secret']
        else
          raise ArgumentError, "You must supply your key and secret"
        end
      end
      @format = 'json'
      uri = URI.parse(API_ENDPOINT)
      @http = Net::HTTP.new uri.host, uri.port
      # @http.use_ssl = true
    end
    
    def find klass, url, options = {}
      klass.load(find_request(klass, url, options))
    end
    
    def direct! manifest, options = {}
      DirectingJob.load(send_manifest(manifest, DirectingJob.endpoint, options))
    end
    
    def render! manifest, options = {}
      RenderingJob.load(send_manifest(manifest, RenderingJob.endpoint, options))
    end
    
    def direct_and_render! manifest, options = {}
      DirectingAndRenderingJob.load(send_manifest(manifest, DirectingAndRenderingJob.endpoint, options))
    end
    
    def reload! resource, options = {}
      resource.load(find_request(resource.class, resource.url, options))
    end
    
    private
    
    def find_request klass, url, options = {}
      request(:get, URI.parse(url).path, nil, { "Accept" => content_type_of(klass) }, options)
    end
    
    def send_manifest manifest, url, options = {}
      request(:post, URI.parse(url).path, manifest.to_json, { "Accept" => "application/#{format}", "Content-Type" => content_type_of(manifest) }, options)
    end
    
    def request method, uri, body, headers = {}, options = {}
      req = build_request method, uri, body, headers, options
      read_response @http.request(req)
    end
    
    def build_request method, uri, body, headers, options
      req = HTTP_METHOD_MAP[method].new uri
      req.body = body
      req.initialize_http_header headers
      req.basic_auth key, secret
      if @debug
        puts
        puts "******************** REQUEST *********************"
        puts "#{req.method} http#{'s' if @http.use_ssl}://#{@http.address}#{req.path} HTTP/#{@http.instance_variable_get(:@curr_http_version)}\r\n"
        req.each_capitalized { |k,v| puts "#{k}: #{v}\r\n"}
        puts "\r\n"
        puts req.body if req.body
        puts "**************************************************"      
        puts
      end
      req
    end
    
    def read_response response
      if @debug
        puts
        puts "******************** RESPONSE ********************"
        response.each_capitalized { |k,v| puts "#{k}: #{v}\r\n"}
        puts "\r\n"
        puts response.body if response.body
        puts "**************************************************"      
        puts
      end
      check_status response
      parse_response response
    end
    
    def check_status response
      raise(response.message) unless (200..299).include?(response.code.to_i)
    end
    
    def parse_response response
      JSON.parse(response.body)
    end
    
    def content_type_of klass_or_instance
      klass = klass_or_instance.is_a?(Class) ? klass_or_instance : klass_or_instance.class
      "#{BASE_CONTENT_TYPE}.#{klass.content_type}-v#{API_VERSION}+#{format}"
    end
    
  end
end