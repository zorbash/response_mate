class ResponseMate::Inspector
  attr_accessor :conn, :base_url, :oauth, :manifest, :print_type

  def initialize(args = {})
    @manifest = args[:manifest]
    @oauth = ResponseMate::Oauth.new
    @base_url = args[:base_url] || manifest.base_url
    @print_type = args[:print] || 'raw'

    if !args[:interactive]
      @conn = ResponseMate::Connection.new(base_url)
      @conn.set_headers_from_manifest(manifest)
    else
      @conn = ResponseMate::Connection.new
    end
  end

  def inspect_key(key, options = {})
    request = manifest.requests.find { |r| r.key == key }
    request = ResponseMate::Manifest.parse_request(request.request)

    puts "[#{key}] #{request[:verb]}".cyan_on_black.bold <<  " #{request[:path]}"
    puts "\tparams #{request[:params]}" if request[:params].present?

    print(conn.fetch(request))
  end

  def inspect_interactive(input)
    request = ResponseMate::Manifest.parse_request(input)
    print(conn.fetch(request))
  end

  def print(response)
    __send__ "print_#{print_type}", response
  end

  def print_raw(response)
    puts "\n"
    status = "#{response.status} #{ResponseMate::Http::STATUS_CODES[response.status]}"
    puts "HTTP/1.1 #{status}"
    response.headers.each_pair do |k, v|
      puts "#{ResponseMate::Helpers.headerize(k)}: #{v}"
    end
    puts response.body
  end

  def print_pretty(response)
    ap({
      status: response.status,
      headers: response.headers,
      body: response.body
    })
  end
end
