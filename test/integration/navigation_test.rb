require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  include PaymentTest::Engine.routes.url_helpers

  test 'can see the payment test info page' do
    get '/payment_test'
    assert_response :success
  end
end

