module DNPP
  module Notifier
    module OperationQueue

      def exec(opt, async)
        if async
          queue.enq(opt)
          wake_operation_thread
        else
          main(opt)
        end
      end

      def wait
        @wait ||= 3
      end

      def wait=(wait)
        @wait = wait
      end

      private

      def queue
        @queue ||= Queue.new
      end

      def operation_thread
        @operation_thread ||= create_operation_thread
      end

      def create_operation_thread
        Thread.new do
          Thread.pass
          while opt = queue.deq
            main(opt)
            sleep wait
          end
        end
      end

      def wake_operation_thread
        @operation_thread = create_operation_thread if operation_thread.status == 'dead'
        operation_thread.wakeup if operation_thread.status == 'sleep'
      end

    end
  end
end
