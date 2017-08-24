require "notifier/version"
require "notifier/pushover"

module DNPP
  module Notifier

    def self.publish!(opt, async)
      Pushover.publish!(opt[:pushover], async) if opt.has_key?(:pushover)
    end

  end
end
