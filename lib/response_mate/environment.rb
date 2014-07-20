# Responsible for parsing the environment file
# The environment file (by default found as environment.yml in a project)
# is a Hash which will be used for the rendering of the requests manifest as a
# [Mustace template](http://mustache.github.io/mustache.5.html).
class ResponseMate::Environment
  attr_accessor :filename, :env, :environment_text

  delegate :[], to: :env

  def initialize(filename)
    @filename = filename || ResponseMate.configuration.environment
    @env = {}
    parse
  end

  private

  def parse
    begin
      @environment_text = File.read filename
    rescue Errno::ENOENT
      puts filename.red << ' does not seem to exist'
      exit 1
    end

    @env = ::YAML.load(environment_text)
  end
end
