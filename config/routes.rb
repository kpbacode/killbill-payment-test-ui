PaymentTest::Engine.routes.draw do

  root to: 'payments#index'

  resources :payments, :only => [:index]

  scope '/payments' do
    match '/set_failed_state' => 'payments#set_failed_state', :via => :post, :as => 'set_failed_state'
    match '/reset' => 'payments#reset', :via => :post, :as => 'reset'
  end

end
