class ResponseMate::Environment
  attr_accessor :filename, :env, :environment_text

  delegate :[], to: :env

  def initialize(filename)
    @filename = filename || ResponseMate.configuration.environment
    @env = {}
    parse
  end

  def parse
    begin
      @environment_text = File.read filename
    rescue Errno::ENOENT
      puts filename.red << ' does not seem to exist'
      exit 1
    end

    @env = YAML.load(environment_text)
  end
end
