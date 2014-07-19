module ResponseMate
  class CLI < ::Thor
    package_name 'response_mate'

    desc 'record', 'Perform requests and record their output'
    method_option :requests_manifest, aliases: '-r'
    method_option :output_dir, aliases: '-o', type: :string
    method_option :keys, aliases: '-k', type: :array, default: []
    def record
      ResponseMate::Commands::Record.new(args, options).run
    rescue ResponseMate::KeysNotFound => e
      puts "The requested keys: #{e.message} could not be found"
    end

    desc 'inspect [key1,key2]', 'Perform requests and print their output'
    method_option :requests_manifest, aliases: '-r'
    def inspect(*keys) # rubocop:disable Lint/UnusedMethodArgument
      ResponseMate::Commands::Inspect.new(args, options).run
    end

    desc 'setup', 'Initialize the required directory structure'
    def setup(output_dir = '') # rubocop:disable Lint/UnusedMethodArgument
      ResponseMate::Commands::Setup.new(args, options).run
    end

    desc 'clear [output_dir]', 'Delete existing response files'
    def clear(output_dir = '') # rubocop:disable Lint/UnusedMethodArgument
      ResponseMate::Commands::Clear.new(args, options).run
    end

    desc 'list [request_type] (requests or recordings)', 'List available recordings' \
    'or keys to record'
    method_option :requests_manifest, aliases: '-r'
    def list(type = 'requests') # rubocop:disable Lint/UnusedMethodArgument
      ResponseMate::Commands::List.new(args, options).run
    end

    desc 'version', 'Print version information'
    def version
      puts "response_mate version #{ResponseMate::VERSION}"
    end
    map ['--version'] => :version

    desc 'export', 'Export manifest or environment to one of the available formats'
    method_option :requests_manifest, aliases: '-r'
    method_option :format, required: true, aliases: '-f', default: 'postman'
    method_option :pretty, aliases: '-p', default: false
    method_option :resource, required: true, aliases: '-res', default: 'manifest'
    method_option :upload, type: :boolean, aliases: '-u'
    def export
      ResponseMate::Commands::Export.new(args, options).run
    end
  end
end
