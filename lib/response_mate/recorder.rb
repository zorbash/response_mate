# coding: utf-8

module ResponseMate
  # Handles recording requests
  class Recorder
    include ResponseMate::ManifestParser

    attr_accessor :base_url, :conn, :manifest, :oauth, :keys

    def initialize(args = {})
      @manifest = args[:manifest]

      @keys = args[:keys]
      @base_url = args[:base_url] || manifest.base_url

      @conn = ResponseMate::Connection.new(base_url)
      @conn.set_headers_from_manifest(manifest)
    end

    def record
      requests = manifest.requests
      requests.select! { |r| keys.include? r.key } if keys.present?
      requests.each do |request|
        process request.key, request
      end
    end

    private

    def process(key, request)
      meta = request.meta
      request = ResponseMate::Manifest.parse_request(request.request)

      puts "[#{key}] #{request[:verb]}".cyan_on_black.bold << " #{request[:path]}"
      puts "\tparams #{request[:params]}" if request[:params].present?
      ResponseMate::Tape.new.write(key, request, conn.fetch(request), meta)
    end
  end
end
