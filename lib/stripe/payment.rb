module Stripe
  class Payment < APIResource

	STATUS = {
		:pending => 'pending',
		:paid => 'paid',
	}
    
	include Stripe::APIOperations::Create
	include Stripe::APIOperations::List
    
  end
end
