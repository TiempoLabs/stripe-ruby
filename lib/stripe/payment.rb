module Stripe
  class Payment < APIResource

	STATUS = {
		:pending => 'pending',
		:paid => 'paid',
		:failed => 'failed',
	}

	METHODS = {
		:ach => 'ach',
	}
    
	include Stripe::APIOperations::Create
	include Stripe::APIOperations::List
    
  end
end
