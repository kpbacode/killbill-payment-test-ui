PaymentTest::Engine.routes.draw do

  root to: 'payment_test#index'

  resources :payment_test, :only => [:index]

  scope '/payment_test' do
    match '/set_failed_state' => 'payment_test#set_failed_state', :via => :post, :as => 'set_failed_state'
    match '/reset' => 'payment_test#reset', :via => :post, :as => 'reset'
  end

end
