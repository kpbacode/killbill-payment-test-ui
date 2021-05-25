# frozen_string_literal: true

require 'payment_test/engine'

module PaymentTest
  mattr_accessor :current_tenant_user
  mattr_accessor :layout

  self.current_tenant_user = lambda { |_session, _user|
    {
      username: 'admin',
      password: 'password',
      session_id: nil,
      api_key: KillBillClient.api_key,
      api_secret: KillBillClient.api_secret
    }
  }

  def self.config
    {
      layout: layout || 'payment_test/layouts/payment_test_application'
    }
  end
end
