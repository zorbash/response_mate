# coding: utf-8

module ResponseMate
  class Recorder
    class InvalidRequestStringError < ArgumentError; end

    HTTP_VERBS = %w(GET POST PUT PATCH DELETE HEAD OPTIONS)
    REQUEST_MATCHER = /^(?<verb>(#{HTTP_VERBS.join('|')})) (?<path>(.)*)$/im
    DEFAULT_HEADERS = {
      'User-Agent' => 'Response-Mate'
    }
    DEFAULT_REQUEST = {
      verb: 'GET'
    }

    attr_accessor :base_url, :conn, :requests_manifest, :manifest, :oauth

    def initialize(args = {})
      @requests_manifest = args[:requests_manifest] || ResponseMate.configuration.
        requests_manifest

      @oauth = ResponseMate::Oauth.new
      parse_requests_manifest

      @base_url = args[:base_url] || manifest.try(:[], 'base_url')
      initialize_connection
    end

    def record
      manifest['requests'].compact.each do |request|
        process request['key'], request['request']
      end
    end

    private

    def preprocess_manifest
      @requests_text = File.read requests_manifest
      if @requests_manifest =~ /\.erb$/
        @requests_text = ERB.new(@requests_text).result(binding)
      end
    end

    def parse_requests_manifest
      puts "Reading request manifest: #{requests_manifest}".underline
      preprocess_manifest
      @manifest = YAML.load(@requests_text)
    end

    def process(key, request)
      request = parse_request_string(request) if request.is_a? String
      request = parse_request_hash(request) if request.is_a? Hash

      if request[:params].present?
        request[:params].merge!({ 'oauth_token' => oauth.token })
      else
        request[:params] = { 'oauth_token' => oauth.token }
      end

      puts "#{request[:verb]}".cyan_on_black.bold <<  " #{request[:path]}"
      puts "\tparams #{request[:params]}" if request[:params].present?
      write_to_file(key, request, fetch(request))
    end

    def fetch(request)
      conn.params = request[:params] if !request[:params].nil?
      conn.send request[:verb].downcase.to_sym, request[:path]
    rescue Faraday::Error::ConnectionFailed
      puts "Is a server up and running at #{request[:path]}?".red
    end

    def parse_request_string(request_string)
      raise InvalidRequestStringError if request_string !~ REQUEST_MATCHER
      { verb: $~[:verb] || DEFAULT_REQUEST[:verb] }.merge(extract_path_query($~[:path]))
    end

    def extract_path_query(str)
      parsed = Addressable::URI.parse(str)
      {
        path: parsed.path,
        params: parsed.query_values
      }
    end

    def parse_request_hash(hash)
      DEFAULT_REQUEST.merge(hash.symbolize_keys)
    end

    def format_request_string(request)
      "#{request[:verb]} #{request[:path]}"
    end

    def initialize_connection
      @conn = Faraday.new do |c|
        c.use FaradayMiddleware::FollowRedirects, limit: 5
        c.adapter Faraday.default_adapter
      end

      conn.headers.merge(DEFAULT_HEADERS)
      set_default_headers_from_manifest
      conn.url_prefix = base_url if base_url
    end

    def set_default_headers_from_manifest
      if manifest.try(:[], 'default_headers')
        manifest['default_headers'].each_pair { |k, v| conn.headers[headerize(k)] = v }
      end
    end

    def write_to_file(key, request, response)
      File.open("#{ResponseMate.configuration.output_dir}#{key}.yml", 'w') do |f|
        f << {
          request: request.select { |_, v| !v.nil? },
          status: response.status,
          headers: response.headers,
          body: response.body
        }.to_yaml
      end
    end

    def headerize(string); string.split('_').map(&:capitalize).join('-') end
  end
end
