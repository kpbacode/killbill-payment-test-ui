require 'payment_test/client'

module PaymentTest
  class PaymentsController < EngineController

    def index
      puts "+++++ INDEX !!!!!"

      begin
        raw_status = ::Killbill::PaymentTest::PaymentTestClient.status(options_for_klient)
      rescue => e
        # No connectivity, GitHub down, ...
        Rails.logger.warn("Unable to get latest plugins, trying built-in directory: #{e.inspect}")
        @status = "UNKNOWN"
      end

      puts "+++++ raw_status = #{raw_status}"

      if raw_status.key? :always_return_plugin_status_error.to_s
        @status = "Plugin configured to return errors"
      elsif raw_status.key? :always_return_plugin_status_pending.to_s
        @status = "Plugin configured to return pending"
      elsif raw_status.key? :always_return_plugin_status_canceled.to_s
        @status = "Plugin configured to return canceled"
      elsif raw_status.key? :always_throw.to_s
        @status = "Plugin configured to throw errors"
      elsif raw_status.key? :always_return_nil.to_s
        @status = "Plugin configured to return null"
      elsif raw_status.key? :sleep_time_sec.to_s
        @status = "Plugin configured to sleep #{sleep_time_sec}"
      else
        @status = "Plugin is in RESET state"
      end

      if raw_status.key? :methods
        @methods = raw_status[:methods]
      end

    end

    def set_failed_state
      #TODO
    end

    def reset
      #TODO
    end

  end
end
