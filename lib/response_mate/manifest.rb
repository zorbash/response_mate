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

  # Parse the requests manifest
  # @return [Array] of requests
  def parse
    preprocess_manifest
    @request_hashes = YAML.load(requests_text).deep_symbolize_keys
    @name = @request_hashes[:name] || filename
    @description = @request_hashes[:description] || ''
    @requests = @request_hashes[:requests].
      map(&:deep_symbolize_keys!).
      map { |rh| ResponseMate::Request.new(rh).normalize! }
  end

  # Filters requests based on the supplied Array of keys
  # @param [Array] keys The keys to lookup for matching requests
  # @return [Array] of matching requests
  def requests_for_keys(keys)
    return [] if keys.empty?

    existing_keys = requests.map(&:key)
    missing_keys = keys - existing_keys

    if missing_keys.present?
      fail ResponseMate::KeysNotFound.new(missing_keys.join(','))
    end

    requests.select! do |r|
      keys.include? r.key
    end
  end

  private

  # Parse the manifest file as a template
  # @return [String] The manifest text parsed as a template
  def preprocess_manifest
    begin
      @requests_text = File.read filename
    rescue Errno::ENOENT
      puts filename.red << ' does not seem to exist'
      exit 1
    end

    if environment.present? # rubocop:disable Style/GuardClause
      @requests_text = Mustache.render(@requests_text, environment.try(:env) || {})
    end
  end
end
