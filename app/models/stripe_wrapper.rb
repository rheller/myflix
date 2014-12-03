module StripeWrapper

  class Customer
    attr_reader :error_message, :response  #gets the instance vars
    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          :plan => options[:plan],
          :card => options[:card],
          :email => options[:user].email
          )
        new(response: response)   #class method returns instance object
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end
    def successful?
      response.present?
    end
  end


  class Charge
    attr_reader :error_message, :response  #gets the instance vars

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => options[:currency],
          :card => options[:card],
          :description => options[:description]
          )
        new(response: response)   #class method returns instance object
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
      
    end
    
###############################
    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def successful?
      response.present?
    end


  end
end
