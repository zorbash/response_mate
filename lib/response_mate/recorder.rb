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
      initialize_connection
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
      write_to_file(key, request, fetch(request), meta)
    end

    def fetch(request)
      conn.params = request[:params] if !request[:params].nil?
      conn.send request[:verb].downcase.to_sym, "#{base_url}#{request[:path]}"
    rescue Faraday::Error::ConnectionFailed
      puts "Is a server up and running at #{request[:path]}?".red
      exit 1
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

    def write_to_file(key, request, response, meta = {})
      File.open("#{ResponseMate.configuration.output_dir}#{key}.yml", 'w') do |f|
        file_content = {
          request: request.select { |_, v| !v.nil? },
          status: response.status,
          headers: response.headers.to_hash,
          body: response.body
        }

        file_content.merge!({ meta: meta }) if meta.present?

        f << file_content.to_yaml
      end
    end

    def headerize(string); string.split('_').map(&:capitalize).join('-') end
  end
end
