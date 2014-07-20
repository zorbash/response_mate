class ResponseMate::Commands::Inspect < ResponseMate::Commands::Base
  attr_reader :inspector
  attr_accessor :history

  def initialize(args, options)
    super(args, options)

    @options[:manifest] = ResponseMate::Manifest.new(options[:requests_manifest])
    @inspector = ResponseMate::Inspector.new(@options)
    @history = []
  end

  def run
    if args.empty?
      return $stderr.puts 'At least one key has to be specified'.red
    end

    args.each do |key|
      inspector.inspect_key(key)
    end
  end
end
