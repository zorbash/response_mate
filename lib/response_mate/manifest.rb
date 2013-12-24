class ResponseMate::Manifest
  include ResponseMate::ManifestParser

  attr_accessor :filename, :requests, :requests_text, :base_url, :oauth

  def initialize(filename)
    @filename = filename || ResponseMate.configuration.requests_manifest
    @oauth = ResponseMate::Oauth.new
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
    @request_hashes = YAML.load(requests_text)
    @base_url = @request_hashes['base_url']
    @requests = @request_hashes['requests'].map { |rh| ResponseMate::Request.new(rh) }
    add_oauth_to_requests
  end

  def add_oauth_to_requests
    @requests.each do |req|
      if req[:params].present?
        req[:params].merge!({ 'oauth_token' => oauth.token })
      else
        req[:params] = { 'oauth_token' => oauth.token }
      end
    end
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
