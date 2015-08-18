class ResponseMate::Commands::Inspect < ResponseMate::Commands::Base
  attr_reader :inspector
  attr_accessor :history

  def run
    environment = ResponseMate::Environment.new(options[:environment])
    options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest],
                                                    environment)

    @inspector = ResponseMate::Inspector.new(options)
    @history = []

    if args.empty?
      return $stderr.puts 'At least one key has to be specified'.red
    end

    args.each do |key|
      inspector.inspect_key(key)
    end
  end
end
