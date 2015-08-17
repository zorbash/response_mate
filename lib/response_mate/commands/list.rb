# Command which performs the operations required by `response_mate list`
class ResponseMate::Commands::List < ResponseMate::Commands::Base
  # Run the command based on args, options provided
  def run
    environment = ResponseMate::Environment.new(options[:environment])
    manifest = ResponseMate::Manifest.new(options[:requests_manifest], environment)

    options[:manifest] = manifest

    puts available_keys.join("\n") << "\n\n"
    action = ask_action

    return if action == :no

    perform_action(action, ask_key(available_keys))
  end

  private

  def available_keys
    options[:manifest].requests.map { |r| r.key.to_sym }
  end

  def ask_action
    choose do |menu|
      menu.prompt = 'Want to perform any of the actions above?'
      menu.choices(:record, :inspect, :no)
    end
  end

  def ask_key(available_keys)
    choose do |menu|
      menu.prompt = 'Which one?'
      menu.choices(*available_keys)
    end.to_s
  end

  def perform_action(action, key)
    case action
    when :record
      ResponseMate::Recorder.new(options).record([key])
    when :inspect
      ResponseMate::Inspector.new(options).inspect_key(key)
    end
  end
end
