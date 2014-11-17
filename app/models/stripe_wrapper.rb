module StripeWrapper

  class Charge
    def initialize(response, status)
      @response = response
      @status = status
    end
   
    def successful?
      @status == :success
    end

    def error_message
      @response.message
    end

    def self.create(options={})
      begin
      Charge.set_api_key
      response = Stripe::Charge.create(
        :amount => options[:amount],
        :currency => options[:currency],
        :card => options[:card],
        :description => options[:description]
        )
      new(response,:success)
      rescue Stripe::CardError => e
      new(e,:error)
      end
    end
    def self.set_api_key
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    end
  end
end
