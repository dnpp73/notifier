require 'pushover'
require 'notifier/log'
require 'notifier/operation_queue'

module DNPP
  module Notifier
    module Pushover
      class << self

        include OperationQueue

        def publish!(opt, async)
          exec(opt, async)
        rescue => e
          log e
        end

        private

        def log(object)
          Notifier.log("[Notifier::Pushover] #{object}")
        end

        def main(o)
          result = false

          Thread.new(o) do |opt|
            Thread.pass
            log "opt => #{opt}"
            result = ::Pushover.notification(opt).to_h
            log "result => #{result}"

            if result['status'] == 1
              retry_count = 0
            else
              retry_count = 3
              log "failed. will retry #{retry_count} times."
            end

            while retry_count > 0 do
              retry_wait  = 5 * (4 - retry_count) # 5, 10, 15
              log "failed. will retry after #{retry_wait} sec."
              sleep retry_wait
              result = ::Pushover.notification(opt).to_h
              log "result => #{result}"

              if result['status'] == 1
                retry_count = 0
              else
                retry_count -= 1
              end            
            end
          end.join(40)

          result
        end
        
      end # class << self
    end # module Pushover
  end # module Notifier
end # module DNPP
