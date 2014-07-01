# coding: utf-8

module ResponseMate
  # Handles recording requests
  class Recorder
    include ResponseMate::ManifestParser

    attr_accessor :conn, :manifest, :keys

    def initialize(args = {})
      @manifest = args[:manifest]
      @conn = ResponseMate::Connection.new
    end

    def record(keys = :all)
      requests = keys == :all ? manifest.requests : manifest.requests_for_keys(keys)

      requests.each { |request| process request }
    end

    private

    def process(request)
      meta = request.meta
      puts request.to_cli_format

      ResponseMate::Tape.new.write(request.key, request, conn.fetch(request), meta)
    end
  end
end
