# coding: utf-8

module ResponseMate
  # Handles recording requests
  class Recorder
    attr_accessor :conn, :manifest, :keys, :output_dir

    def initialize(args = {})
      @manifest = args[:manifest]
      @conn = ResponseMate::Connection.new
      @output_dir = args[:output_dir]
    end

    def record(keys)
      requests = keys.empty? ? manifest.requests : manifest.requests_for_keys(keys)

      requests.each { |request| process request }
    end

    private

    def process(request)
      meta = request.meta
      puts request.to_cli_format

      ResponseMate::Tape.new.write(request.key,
                                   request,
                                   conn.fetch(request),
                                   meta,
                                   output_dir)
    end
  end
end
