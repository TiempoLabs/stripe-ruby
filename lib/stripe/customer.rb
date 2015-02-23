module Stripe
  class Customer < APIResource
    include Stripe::APIOperations::Create
    include Stripe::APIOperations::Delete
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::List

    def add_invoice_item(params, opts={})
      opts = @opts.merge(Util.normalize_opts(opts))
      InvoiceItem.create(params.merge(:customer => id), opts)
    end

    def invoices
      Invoice.all({ :customer => id }, @opts)
    end

    def invoice_items
      InvoiceItem.all({ :customer => id }, @opts)
    end

    def upcoming_invoice
      Invoice.upcoming({ :customer => id }, @opts)
    end

    def charges
      Charge.all({ :customer => id }, @opts)
    end

    def create_upcoming_invoice(params={}, opts={})
      opts = @opts.merge(Util.normalize_opts(opts))
      Invoice.create(params.merge(:customer => id), opts)
    end

    def cancel_subscription(params={}, opts={})
      response, opts = request(:delete, subscription_url, params, opts)
      refresh_from({ :subscription => response }, opts, true)
      subscription
    end

    def update_subscription(params={}, opts={})
      response, opts = request(:post, subscription_url, params, opts)
      refresh_from({ :subscription => response }, opts, true)
      subscription
    end

    def create_subscription(params={}, opts={})
      response, opts = request(:post, subscriptions_url, params, opts)
      refresh_from({ :subscription => response }, opts, true)
      subscription
    end

    def delete_discount
      _, opts = request(:delete, discount_url)
      refresh_from({ :discount => nil }, opts, true)
    end

    def create_bank_account(params, api_key=nil)
      api_key ||= @api_key
      response, api_key = Stripe.request(:post, bank_accounts_url, api_key, params)
      account = BankAccount.construct_from(response)
      self.refresh
      return account
    end

    def verify_bank_account(params, api_key=nil, account=nil)
      api_key ||= @api_key
      account ||= self.default_bank_account
      response, api_key = Stripe.request(:post, bank_verify_url(account), api_key, params)
      account = BankAccount.construct_from(response)
      self.refresh
      return account
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

      if (self.respond_to?(:default_bank_account))
        bank_account_id = self.default_bank_account
        response = self.bank_accounts.data.select{ |account| account.id == bank_account_id }.first
      end

      return response
    end

    private

    def discount_url
      url + '/discount'
    end

    def subscription_url
      url + '/subscription'
    end

    def subscriptions_url
      url + '/subscriptions'
    end

    def bank_accounts_url
      url + '/bank_accounts'
    end

    def bank_verify_url(account)
      bank_accounts_url + '/' + account + '/verify'
    end

  end
end
