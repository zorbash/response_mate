# Responsible for parsing the environment file
# The environment file (by default found as environment.yml in a project)
# is a Hash which will be used for the rendering of the requests manifest as a
# [Mustace template](http://mustache.github.io/mustache.5.html).
class ResponseMate::Environment
  attr_accessor :filename

  delegate :[], to: :env

  def initialize(filename)
    @filename = filename || ResponseMate.configuration.environment
  end

  # Check for environment file existence
  # @return [TrueClass|FalseClass]
  def exists?
    File.exist? filename
  end

  # Set the env to the parsed YAML environment file
  def env
    @env ||= exists? ? YAML.load_file(filename) : {}
  end
end
