# coding: utf-8

module ResponseMate
  class Thor < ::Thor
    package_name 'response_mate'

    desc 'Perform requests and records their output', 'Records'
    method_option :base_url
    method_option :requests_manifest
    method_option :keys
    def record
      ResponseMate::Recorder.new(options.symbolize_keys).record
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

    desc 'Exports to one of the available formats', 'Exports'
    method_option :requests_manifest
    method_option :format
    method_option :pretty, default: false
    def export
      output = ResponseMate::Exporter.new(options.symbolize_keys).export
      if options[:pretty]
        puts JSON.pretty_generate(output)
      else
        puts output.to_json
      end
    end
  end
end
