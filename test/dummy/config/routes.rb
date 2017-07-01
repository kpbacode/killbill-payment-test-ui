Rails.application.routes.draw do

  mount PaymentTest::Engine => "/payment_test"
end
