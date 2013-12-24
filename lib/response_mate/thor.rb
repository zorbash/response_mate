# coding: utf-8
Signal.trap('EXIT') { puts 'Exiting..' }

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
    end

    desc 'Initializes the required directory structure', 'Initializes'
    def setup
      FileUtils.mkdir_p ResponseMate.configuration.output_dir
    end

    desc 'Deletes existing response files', 'Cleans up recordings'
    def clear
      FileUtils.rm_rf(ResponseMate.configuration.output_dir + '.')
      puts "All clean and shiny!"
    end

    desc 'Lists available recordings', 'Recording listing'
    def list
      Dir.glob('output/responses/*.yml').map do |f|
        puts File.basename(f).gsub(/\.yml/, '')
      end
    end

    desc 'Lists available recordings or keys to record', 'Recording listing'
    method_option :requests_manifest, aliases: '-r'
    def list(type = "requests")
      opts = options.dup.symbolize_keys
      manifest = ResponseMate::Manifest.new(opts[:requests_manifest])

      if type == "requests"
        choices = manifest['requests'].map { |r| r['key'].to_sym }
      elsif type == "recordings"
        choices = Dir.glob('output/responses/*.yml').map do |f|
          File.basename(f).gsub(/\.yml/, '').to_sym
        end
      end

      key = choose { |menu|
        menu.prompt = 'Record any of the following?'
        menu.choices(*choices)
      }.to_s

      ResponseMate::Recorder.new({ manifest: manifest, keys: [key] }).record if key
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
