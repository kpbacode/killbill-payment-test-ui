# frozen_string_literal: true

# Dependencies
#
# Sigh. Rails autoloads the gems specified in the Gemfile and nothing else.
# We need to explicitly require all of our dependencies listed in payment_test.gemspec
#
# See also https://github.com/carlhuda/bundler/issues/49
require 'jquery-rails'
require 'font-awesome-rails'
require 'twitter-bootstrap-rails'
require 'killbill_client'

module PaymentTest
  class Engine < ::Rails::Engine
    isolate_namespace PaymentTest
  end
end
