module Capybara
  module Widgets
    module AsyncHelper
      def eventually(options = {})
        timeout = options[:timeout] || 10
        interval = options[:interval] || 0.1
        time_limit = Time.now + timeout
        loop do
          begin
            result = yield
          rescue => error
          end
          return result if error.nil?
          raise error if Time.now >= time_limit
          sleep interval
        end
      end
    end
  end
end
