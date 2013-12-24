module ResponseMate::Helpers
  def self.headerize(string); string.split('_').map(&:capitalize).join('-') end
end
