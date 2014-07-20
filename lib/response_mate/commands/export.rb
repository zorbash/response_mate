# Command which performs the operations required by `response_mate list`
class ResponseMate::Commands::Export < ResponseMate::Commands::Base
  def initialize(args, options)
    super(args, options)
    @type = args.first || 'requests'

    @options[:environment] = ResponseMate::Environment.new(options[:environment])
    @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
  end

  # Run the command based on args, options provided
  def run
    output = ResponseMate::Exporter.new(options).export
    if options[:upload]
      url = Faraday.post 'http://getpostman.com/collections' do |req|
        req.body = output.to_json
      end
      puts JSON.parse(url.body)['link']
    else
      puts JSON.pretty_generate(output)
    end
  end
end
