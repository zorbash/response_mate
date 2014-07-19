class ResponseMate::Inspector
  attr_accessor :conn, :manifest

  def initialize(args = {})
    @manifest = args[:manifest]

    @conn = ResponseMate::Connection.new
  end

  def inspect_key(key)
    request = manifest.requests.find { |r| r.key == key }

    puts request.to_cli_format
    print_pretty(conn.fetch(request))
  end

  def print_pretty(response)
    ap(status: response.status,
       headers: response.headers,
       body: response.body)
  end
end
