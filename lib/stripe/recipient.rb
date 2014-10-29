module Stripe
  class Recipient < APIResource
    include Stripe::APIOperations::Create
    include Stripe::APIOperations::Delete
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::List

    def transfers
      Transfer.all({ :recipient => id }, @api_key)
    end
    
    def get_default_card
      response = nil

      if (self.respond_to?(:default_card))
        card_id = self.default_card
        response = self.cards.data.select{ |card| card.id == card_id }.first
      end

      return response
    end

    def get_default_bank_account
      response = nil

      if (self.respond_to?(:active_account))
        response = self.active_account
      end

      return response
    end
  end
end
