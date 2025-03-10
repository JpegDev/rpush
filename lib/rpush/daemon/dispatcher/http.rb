module Rpush
  module Daemon
    module Dispatcher
      class Http
        def initialize(app, delivery_class, _options = {})
          @app = app
          @delivery_class = delivery_class
          proxy = ENV["http_proxy"]
          if proxy.blank?
            @http = Net::HTTP::Persistent.new('rpush')
          else
            @http = Net::HTTP::Persistent.new('rpush', proxy)
          end
        end

        def dispatch(payload)
          @delivery_class.new(@app, @http, payload.notification, payload.batch).perform
        end

        def cleanup
          @http.shutdown
        end
      end
    end
  end
end
