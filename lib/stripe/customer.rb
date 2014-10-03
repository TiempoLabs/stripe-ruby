module Stripe
  class Customer < APIResource
    include Stripe::APIOperations::Create
    include Stripe::APIOperations::Delete
    include Stripe::APIOperations::Update
    include Stripe::APIOperations::List

    def add_invoice_item(params)
      InvoiceItem.create(params.merge(:customer => id), @api_key)
    end

    def invoices
      Invoice.all({ :customer => id }, @api_key)
    end

    def invoice_items
      InvoiceItem.all({ :customer => id }, @api_key)
    end

    def upcoming_invoice
      Invoice.upcoming({ :customer => id }, @api_key)
    end

    def charges
      Charge.all({ :customer => id }, @api_key)
    end

    def create_upcoming_invoice(params={})
      Invoice.create(params.merge(:customer => id), @api_key)
    end

    def cancel_subscription(params={})
      response, api_key = Stripe.request(:delete, subscription_url, @api_key, params)
      refresh_from({ :subscription => response }, api_key, true)
      subscription
    end

    def update_subscription(params)
      response, api_key = Stripe.request(:post, subscription_url, @api_key, params)
      refresh_from({ :subscription => response }, api_key, true)
      subscription
    end

    def create_subscription(params)
      response, api_key = Stripe.request(:post, subscriptions_url, @api_key, params)
      refresh_from({ :subscription => response }, api_key, true)
      subscription
    end

    def delete_discount
      Stripe.request(:delete, discount_url, @api_key)
      refresh_from({ :discount => nil }, api_key, true)
    end

    def create_bank_account(params, api_key=nil)
      api_key ||= @api_key
      response, api_key = Stripe.request(:post, bank_accounts_url, api_key, params)
      return response
    end

    def verify_bank_account(params, account=nil)
      account ||= self.default_bank_account
      response, api_key = Stripe.request(:post, bank_verify_url(account), @api_key, params)
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
