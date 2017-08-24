module DNPP
  module Notifier
    
    def self.log(text)
      puts "(#{Time.now.localtime})#{text}"
    end

  end
end
