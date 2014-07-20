# All commands are namespaced by this module
module ResponseMate::Commands
  autoload :Base, 'response_mate/commands/base'
  autoload :Record, 'response_mate/commands/record'
  autoload :Inspect, 'response_mate/commands/inspect'
  autoload :List, 'response_mate/commands/list'
  autoload :Export, 'response_mate/commands/export'
  autoload :Setup, 'response_mate/commands/setup'
  autoload :Clear, 'response_mate/commands/clear'
end
