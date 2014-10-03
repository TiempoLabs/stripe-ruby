module Stripe
  class Payment < APIResource
    
	include Stripe::APIOperations::Create
	include Stripe::APIOperations::List
    
  end
end
