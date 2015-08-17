module ResponseMate
  # Entry point of the command-line interface
  class CLI < ::Thor
    package_name 'response_mate'

    desc 'record', 'Perform requests and record their output'
    method_option :requests_manifest, aliases: '-r', banner:
      'requests.yml'
    method_option :output_dir, aliases: '-o', type: :string, banner:
      './a_dir_to_place_the_recordings'
    method_option :keys, aliases: '-k', type: :array, default: [], banner:
      'key_to_record1 key_to_record2'
    def record
      ResponseMate::Commands::Record.new(args, options).run
    end

    desc 'inspect [key1,key2]', 'Perform requests and print their output'
    method_option :requests_manifest, aliases: '-r', banner:
      'requests.yml'
    def inspect(*keys) # rubocop:disable Lint/UnusedMethodArgument
      ResponseMate::Commands::Inspect.new(args, options).run
    end

    desc 'list', 'List available keys to record or inspect'
    method_option :requests_manifest, aliases: '-r', banner:
      'requests.yml'
    method_option :output_dir, aliases: '-o', type: :string, banner:
      './a_dir_to_place_the_recordings'
    def list # rubocop:disable Lint/UnusedMethodArgument
      ResponseMate::Commands::List.new(args, options).run
    end

    desc 'version', 'Print version information'
    def version
      puts "response_mate version #{ResponseMate::VERSION}"
    end
    map ['--version'] => :version

    desc 'export', 'Export manifest or environment to one of the available formats'
    method_option :requests_manifest, aliases: '-r', banner:
      'requests.yml'
    method_option :format, required: true, aliases: '-f', default: 'postman', banner:
      'postman'
    method_option :pretty, aliases: '-p', default: false, banner:
      'true(Formats Output)|false'
    method_option :resource, required: true, aliases: '-res', default: 'manifest', banner:
      'environment(variables)|manifest(requests)'
    method_option :upload, type: :boolean, aliases: '-u', banner:
      'true(Uploads and displays the link)'
    def export
      ResponseMate::Commands::Export.new(args, options).run
    end
  end
end
