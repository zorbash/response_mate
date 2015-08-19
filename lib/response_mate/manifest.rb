# Responsible for parsing the requests manifest file to
# actually operate on the requests
class ResponseMate::Manifest
  attr_accessor :filename, :requests, :requests_text, :environment
  attr_reader :name, :description

  def initialize(filename, environment = nil)
    @filename = filename || ResponseMate.configuration.requests_manifest
    @environment = environment
    parse
  end

  # Filters requests based on the supplied Array of keys
  # @param [Array] keys The keys to lookup for matching requests
  # @return [Array] of matching requests
  def requests_for_keys(keys)
    return [] if keys.blank?

    existing_keys = requests.map(&:key)
    missing_keys = keys - existing_keys

    if missing_keys.present?
      fail ResponseMate::KeysNotFound.new(missing_keys.join(', '))
    end

    requests.select! do |r|
      keys.include? r.key
    end
  end

  private

  # Parse the requests manifest
  # @return [Array] of requests
  def parse
    preprocess_manifest
    parsed_manifest = YAML.load(@requests_text).deep_symbolize_keys
    @name = parsed_manifest.fetch(:name, filename)
    @description = parsed_manifest.fetch(:description, '')
    check_requests(parsed_manifest)
    @requests = parsed_manifest.
      fetch(:requests, []). # rubocop:disable Style/MultilineOperationIndentation
      map(&:deep_symbolize_keys!). # rubocop:disable Style/MultilineOperationIndentation
      map { |rh| ResponseMate::Request.new(rh).normalize! } # rubocop:disable Style/MultilineOperationIndentation
  end

  # Parse the manifest file as a template
  # @return [String] The manifest text parsed as a template
  def preprocess_manifest
    begin
      @requests_text = File.read filename
    rescue Errno::ENOENT
      raise ResponseMate::ManifestMissing.new(filename)
    end

    process_mustache! if environment.present? && mustache?
  end

  # Check if the manifest file is a Mustache template
  def mustache?
    requests_text =~ /{{.*}}/
  end

  # Evaluate Mustache template
  def process_mustache!
    check_environment

    @requests_text = Mustache.render(requests_text, environment.env)
  end

  def check_environment
    return if environment.exists?

    warning = 'The specified requests file is a template, but no environment file is found.'
    guide = <<-GUIDE
    The environment file holds any variables you wish to be interpolated.
    You may specify a different environment file using the -e [file.yml] option.
    Default: environment.yml
    GUIDE

    STDERR.puts warning.yellow, guide
  end

  def check_requests(parsed_manifest)
    return if parsed_manifest.key? :requests

    gemspec = Gem::Specification.find_by_name('response_mate')
    example_manifest = "#{gemspec.homepage}/blob/master/requests.yml.sample"

    warning = 'The specified requests file contains no requests.'
    guide = <<-GUIDE
    To declare requests place them under the :requests key.
    Example manifest: #{example_manifest}
    GUIDE

    STDERR.puts warning.yellow, guide
  end
end
