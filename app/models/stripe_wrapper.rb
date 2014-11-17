module StripeWrapper

  class Charge

    def self.create(options={})
      begin
      Charge.set_api_key
      response = Stripe::Charge.create(
        :amount => options[:amount],
        :currency => options[:currency],
        :card => options[:card],
        :description => options[:description]
        )
      rescue Stripe::CardError => e
        return e.message
      end
    end
    
    def self.set_api_key
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    end
  end
end
