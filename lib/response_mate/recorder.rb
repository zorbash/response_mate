# coding: utf-8

module ResponseMate
  class Recorder
    include ResponseMate::ManifestParser

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

    def process(key, request)
      request = parse_request(request)

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
