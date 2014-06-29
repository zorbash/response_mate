# coding: utf-8

module ResponseMate
  # Handles recording requests
  class Recorder
    include ResponseMate::ManifestParser

    attr_accessor :conn, :manifest, :keys

    def initialize(args = {})
      @manifest = args[:manifest]
      @keys = args[:keys]
      @conn = ResponseMate::Connection.new
    end

    def record
      requests = manifest.requests

      if keys.present?
        existing_keys = requests.map(&:key)
        missing_keys = keys - existing_keys

        if missing_keys.present?
          raise ResponseMate::KeysNotFound.new(missing_keys.join(','))
        end

        requests.select! do |r|
          keys.include? r.key
        end
      end

      requests.each do |request|
        process request.key, request
      end
    end

    private

    def process(key, request)
      meta = request.meta
      puts request.to_cli_format

      ResponseMate::Tape.new.write(key, request, conn.fetch(request), meta)
    end
  end
end
