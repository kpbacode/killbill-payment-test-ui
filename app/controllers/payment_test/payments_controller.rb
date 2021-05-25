# frozen_string_literal: true

require 'payment_test/client'

module PaymentTest
  class PaymentsController < EngineController
    def index
      begin
        raw_status = ::Killbill::PaymentTest::PaymentTestClient.status(options_for_klient)
      rescue StandardError => e
        Rails.logger.warn("Failed to retrieve payment status : #{e}")
      end

      @status = if raw_status.nil?
                  'UNKNOWN'
                elsif raw_status.key? :always_return_plugin_status_error.to_s
                  'RETURN ERROR'
                elsif raw_status.key? :always_return_plugin_status_pending.to_s
                  'RETURN PENDING'
                elsif raw_status.key? :always_return_plugin_status_canceled.to_s
                  'RETURN CANCELED'
                elsif raw_status.key? :always_throw.to_s
                  'RETURN THROW'
                elsif raw_status.key? :always_return_nil.to_s
                  'RETURN NULL '
                elsif raw_status.key? :sleep_time_sec.to_s
                  "SLEEP #{sleep_time_sec}"
                else
                  'CLEAR'
                end

      @methods = if raw_status.nil?
                   ['*']
                 elsif !raw_status.key?('methods') || raw_status['methods'].empty?
                   ['*']
                 else
                   raw_status['methods']
                 end
    end

    def set_failed_state
      new_state = params.require(:state)
      target_method = "set_status_#{new_state.to_s.downcase}".to_sym

      begin
        ::Killbill::PaymentTest::PaymentTestClient.send(target_method, nil, options_for_klient)
      rescue StandardError => e
        flash[:error] = "Failed to set state: #{e}"
      end

      redirect_to root_path and return
    end

    def reset
      begin
        ::Killbill::PaymentTest::PaymentTestClient.reset(nil, options_for_klient)
      rescue StandardError => e
        flash[:error] = "Failed to reset state: #{e}"
      end
      redirect_to root_path and return
    end
  end
end
