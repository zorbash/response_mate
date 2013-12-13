module ResponseMate::ManifestParser
  HTTP_VERBS = %w(GET POST PUT PATCH DELETE HEAD OPTIONS)
  REQUEST_MATCHER = /^(?<verb>(#{HTTP_VERBS.join('|')})) (?<path>(.)*)$/im
  DEFAULT_HEADERS = {
    'User-Agent' => 'Response-Mate'
  }
  DEFAULT_REQUEST = {
    verb: 'GET'
  }

  def preprocess_manifest
    begin
      @requests_text = File.read requests_manifest
    rescue Errno::ENOENT
      puts requests_manifest.red << " does not seem to exist"
      exit 1
    end
    if @requests_manifest =~ /\.erb$/
      @requests_text = ERB.new(@requests_text).result(binding)
    end
  end

  def parse_request(request)
    return parse_request_string(request) if request.is_a? String
    parse_request_hash(request) if request.is_a? Hash
  end

  def parse_requests_manifest
    preprocess_manifest
    @manifest = YAML.load(@requests_text)
  end

  def parse_request_hash(hash)
    DEFAULT_REQUEST.merge(hash.symbolize_keys)
  end

  def parse_request_string(request_string)
    raise ArgumentError if request_string !~ REQUEST_MATCHER
    { verb: $~[:verb] || DEFAULT_REQUEST[:verb] }.merge(extract_path_query($~[:path]))
  end

  def extract_path_query(str)
    parsed = Addressable::URI.parse(str)
    {
      path: parsed.path,
      params: parsed.query_values
    }
  end
end
