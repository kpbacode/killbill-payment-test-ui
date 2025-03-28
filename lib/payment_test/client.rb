# frozen_string_literal: true

require 'json'

module Killbill
  module PaymentTest
    class PaymentTestClient < KillBillClient::Model::Resource
      KILLBILL_PAYMENT_TEST_PREFIX = '/plugins/killbill-payment-test'
      class << self
        def status(options = {})
          response = KillBillClient::API.get "#{KILLBILL_PAYMENT_TEST_PREFIX}/status",
                                             {},
                                             options
          JSON.parse(response.body)
        end

        def set_status_pending(methods, options = {})
          configure('ACTION_RETURN_PLUGIN_STATUS_PENDING', nil, methods, options)
        end

        def set_status_error(methods, options = {})
          configure('ACTION_RETURN_PLUGIN_STATUS_ERROR', nil, methods, options)
        end

        def set_status_canceled(methods, options = {})
          configure('ACTION_RETURN_PLUGIN_STATUS_CANCELED', nil, methods, options)
        end

        def set_sleep_time(sleep_time_sec, methods, options = {})
          configure('ACTION_SLEEP', sleep_time_sec, methods, options)
        end

        def set_status_throw(methods, options = {})
          configure('ACTION_THROW_EXCEPTION', nil, methods, options)
        end

        def set_status_null(methods, options = {})
          configure('ACTION_RETURN_NIL', nil, methods, options)
        end

        def reset(methods, options = {})
          configure('ACTION_RESET', nil, methods, options)
        end

        private

        def configure(action, arg, methods, options = {})
          body = {
            'CONFIGURE_ACTION' => action
          }

          body['SLEEP_TIME_SEC'] = arg if action == 'ACTION_RESET'

          body['METHODS'] = methods.nil? ? nil : methods.join(',')

          KillBillClient::API.post "#{KILLBILL_PAYMENT_TEST_PREFIX}/configure",
                                   body.to_json,
                                   {},
                                   {
                                     user: 'anonymous',
                                     reason: 'TEST',
                                     comment: 'TEST'
                                   }.merge(options)
        end
      end
    end
  end
end
