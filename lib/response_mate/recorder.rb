# coding: utf-8

module ResponseMate
  class Recorder
    include ResponseMate::ManifestParser

    attr_accessor :base_url, :conn, :requests_manifest, :manifest, :oauth, :keys

    def initialize(args = {})
      @manifest = args[:manifest]

      @keys = args[:keys]
      @oauth = ResponseMate::Oauth.new
      @base_url = args[:base_url] || manifest.try(:[], 'base_url')

      @conn = ResponseMate::Connection.new(base_url)
      @conn.set_headers_from_manifest(manifest)
    end

    def record
      requests = manifest['requests'].compact
      requests.select! { |r| keys.include? r['key'] } if keys.present?
      requests.each do |request|
        process request['key'], request
      end
    end

    private

    def process(key, request)
      meta = request['meta']
      request = ResponseMate::Manifest.parse_request(request['request'])

      if request[:params].present?
        request[:params].merge!({ 'oauth_token' => oauth.token })
      else
        request[:params] = { 'oauth_token' => oauth.token }
      end

      puts "[#{key}] #{request[:verb]}".cyan_on_black.bold <<  " #{request[:path]}"
      puts "\tparams #{request[:params]}" if request[:params].present?
      Tape.new.write(key, request, conn.fetch(request), meta)
    end
  end
end
