# coding: utf-8

module ResponseMate
  class CLI < ::Thor
    package_name 'response_mate'

    desc 'Perform requests and records their output', 'Records'
    method_option :base_url, aliases: '-b'
    method_option :requests_manifest, aliases: '-r'
    method_option :keys, aliases: '-k', type: :array
    def record
      ResponseMate::Commands::Record.new(args, options).run

    rescue ResponseMate::OutputDirError
      puts 'Output directory does not exist, invoking setup..'
      puts 'Please retry after setup'
      invoke :setup, []
    end

    desc 'Perform requests and prints their output', 'Records'
    method_option :base_url, aliases: '-b'
    method_option :requests_manifest, aliases: '-r'
    method_option :interactive, type: :boolean, aliases: "-i"
    method_option :print, type: :string, aliases: '-p', default: 'raw'
    def inspect(*keys)
      ResponseMate::Commands::Inspect.new(args, options).run
    end

    desc 'Initializes the required directory structure', 'Initializes'
    def setup(output_dir = ResponseMate.configuration.output_dir)
      FileUtils.mkdir_p(output_dir)
      puts "[Setup] Initialized empty directory #{output_dir}"
    end

    desc 'Deletes existing response files', 'Cleans up recordings'
    def clear
      FileUtils.rm_rf(ResponseMate.configuration.output_dir + '.')
      puts "All clean and shiny!"
    end

    desc 'Lists available recordings or keys to record', 'Recording listing'
    method_option :requests_manifest, aliases: '-r'
    def list(type = 'requests')
      ResponseMate::Commands::List.new(args, options).run

    rescue ResponseMate::OutputDirError
      puts 'Output directory does not exist, invoking setup..'
      puts 'Please retry after setup'
      invoke :setup, []
    end

    desc 'Exports to one of the available formats', 'Exports'
    method_option :requests_manifest, aliases: '-r'
    method_option :format, aliases: '-f'
    method_option :pretty, aliases: '-p', default: false
    def export
      ResponseMate::Commands::Export.new(args, options).run
    end
  end
end
