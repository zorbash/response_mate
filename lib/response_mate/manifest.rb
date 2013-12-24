class ResponseMate::Manifest
  include ResponseMate::ManifestParser

  delegate :[], to: :requests

  attr_accessor :filename, :requests, :requests_text

  def initialize(filename)
    @filename = filename || ResponseMate.configuration.requests_manifest
    parse
  end

  def preprocess_manifest
    begin
      @requests_text = File.read filename
    rescue Errno::ENOENT
      puts filename.red << " does not seem to exist"
      exit 1
    end

    environment = {} # Later to be replaced by a hash of the environment vars
    @requests_text = Mustache.render(@requests_text, environment)
  end

  def parse
    preprocess_manifest
    @requests = YAML.load(requests_text)
  end

  class << self
    def parse_request(request)
      return parse_request_string(request) if request.is_a? String
      parse_request_hash(request) if request.is_a? Hash
    end

    def parse_request_hash(hash)
      self::DEFAULT_REQUEST.merge(hash.symbolize_keys)
    end

    def parse_request_string(request_string)
      raise ArgumentError if request_string !~ self::REQUEST_MATCHER
      { verb: $~[:verb] || self::DEFAULT_REQUEST[:verb] }
        .merge(extract_path_query($~[:path]))
    end

    def extract_path_query(str)
      parsed = Addressable::URI.parse(str)
      {
        path: parsed.path,
        params: parsed.query_values
      }
    end
  end
end
