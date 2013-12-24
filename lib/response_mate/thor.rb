# coding: utf-8

module ResponseMate
  class Thor < ::Thor
    package_name 'response_mate'

    desc 'Perform requests and records their output', 'Records'
    method_option :base_url, aliases: '-b'
    method_option :requests_manifest, aliases: '-r'
    method_option :keys, aliases: '-k', type: :array
    def record
      opts = options.dup.symbolize_keys
      opts[:manifest] = ResponseMate::Manifest.new(opts[:requests_manifest])
      ResponseMate::Recorder.new(opts).record

      File.open(ResponseMate.configuration.output_dir + '.last_recording', 'w') do |f|
        f << Time.current
      end

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
    def list(type = "requests")
      opts = options.dup.symbolize_keys
      manifest = ResponseMate::Manifest.new(opts[:requests_manifest])

      if type == "requests"
        choices = manifest.requests.map { |r| r.key.to_sym }
      elsif type == "recordings"
        choices = Dir.glob('output/responses/*.yml').map do |f|
          File.basename(f).gsub(/\.yml/, '').to_sym
        end
      end

      puts choices.join "\n"
      puts "\n\n"
      action = choose { |menu|
        menu.prompt = 'Want to perform any of the following actions?'
        menu.choices(:record, :inspect, :no)
      }

      unless action == :no
        key = choose { |menu|
          menu.prompt = 'Which one?'
          menu.choices(*choices)
        }.to_s
      end

      if key
        case action
        when :record
          ResponseMate::Recorder.new({ manifest: manifest, keys: [key] }).record if key
        when :inspect
          ResponseMate::Inspector.new(manifest: manifest).inspect_key(key)
        end
      end

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
      opts = options.dup
      unless options[:format].present?
        opts[:format] = choose { |menu|
          menu.prompt = "Please pick one of the available formats"
          menu.choice(:postman)
        }.to_s
      end

      output = ResponseMate::Exporter.new(opts.symbolize_keys).export
      if options[:pretty]
        puts JSON.pretty_generate(output)
      else
        puts output.to_json
      end
    end
  end
end
