class ResponseMate::Exporters::Postman
  # Handles exporting to postman format
  # Example output
  # https://www.getpostman.com/collections/dbc0521911e45471ff4a
  class Environment
    attr_accessor :environment, :out

    def initialize(environment)
      @environment = environment
      @out = {}
    end

    # Export the environment
    def export
      build_structure
      build_values
      out
    end

    private

    def build_structure
      out.merge!(
        id: SecureRandom.uuid,
        name: 'exported_environment',
        values: [],
        timestamp: Time.now.to_i
      )
    end

    def build_values
      environment.env.each_pair do |k, v|
        out_val = {
          key: k,
          value: v,
          type: 'text'
        }

        out[:values] << out_val
      end
    end
  end
end
