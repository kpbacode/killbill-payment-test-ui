require 'payment_test/client'

module PaymentTest
  class PaymentsController < EngineController

    def index
      begin
        raw_status = ::Killbill::PaymentTest::PaymentTestClient.status(options_for_klient)
      rescue => e
        # No connectivity, GitHub down, ...
        Rails.logger.warn("Unable to get latest plugins, trying built-in directory: #{e.inspect}")
        @status = "UNKNOWN"
      end

      if raw_status.key? :always_return_plugin_status_error.to_s
        @status = "RETURN ERROR"
      elsif raw_status.key? :always_return_plugin_status_pending.to_s
        @status = "RETURN PENDING"
      elsif raw_status.key? :always_return_plugin_status_canceled.to_s
        @status = "RETURN CANCELED"
      elsif raw_status.key? :always_throw.to_s
        @status = "RETURN THROW"
      elsif raw_status.key? :always_return_nil.to_s
        @status = "RETURN NULL "
      elsif raw_status.key? :sleep_time_sec.to_s
        @status = "SLEEP #{sleep_time_sec}"
      else
        @status = "CLEAR"
      end

      @methods = raw_status.key?("methods") ? raw_status["methods"] : ['*']
    end

    def set_failed_state
      #TODO
    end

    def reset
      #TODO
    end

  end
end
